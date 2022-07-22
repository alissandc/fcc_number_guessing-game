#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME
#

GAME_FUNCTION() {
NUMBER=$(( RANDOM % 1001 ))
echo "this is the number $NUMBER."
echo "Guess the secret number between 1 and 1000:"
read GUESS
until [[ $GUESS =~ ^[0-9]+$ ]]
do
  echo "That is not an integer, guess again:"
  read GUESS again
done
let COUNT=0
  while [[ $GUESS -ne $NUMBER ]]
    do
    if [[ $GUESS -ge $NUMBER ]]
    then
      echo "It's lower than that, guess again:"
      read GUESS
      (( COUNT++ ))
    else
      echo "It's higher than that, guess again:"
      read GUESS
      (( COUNT++ ))
    fi
  done
  if [[ $GUESS =~ $NUMBER ]]
    then
      (( COUNT++ ))
      echo "You guessed it in $COUNT tries. The secret number was $NUMBER. Nice job!"
      UPDATE_GAMES_PLAYED=$($PSQL "UPDATE customers SET games_played=games_played+1 WHERE name='$USERNAME'")
      #UPDATE_BEST_GAME
      BEST_GAME2=$($PSQL "SELECT best_game FROM customers WHERE name='$USERNAME'")
      UPDATE_BEST_GAME=$($PSQL "UPDATE customers SET best_game=$COUNT WHERE name='$USERNAME'")
    fi
}
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE name='$USERNAME'")

if [[ -z $CUSTOMER_NAME ]]
  then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_NEW_USERNAME=$($PSQL "INSERT INTO customers(name) VALUES('$USERNAME')")
  GAME_FUNCTION $USERNAME
  else 
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM customers WHERE name='$USERNAME'")
  BEST_GAME=$($PSQL "SELECT best_game FROM customers WHERE name='$USERNAME'")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  GAME_FUNCTION $USERNAME
fi

