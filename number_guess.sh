#! /bin/bash

#assign database call to variable PSQL
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align --tuples-only -c"
#generates a random number from 1 to 1000
R_NUMBER=$(( RANDOM % 1000 + 1 ))

#Get user credentials
echo Enter your username:
read USERNAME

USER_CHECK=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
#if username not in database
if [[ -z $USER_CHECK ]]
then
  USER_INSERT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  #get best_game value -> usefull for later logic
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME'")
#if user is in the database
else
  #import number of games played and increvent it's value
  N_GAMES=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME'")
  #get best_game value
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME'")
  #welcome back to the past users
  echo "Welcome back, $USERNAME! You have played $N_GAMES games, and your best game took $BEST_GAME guesses."
  N_GAMES=$(($N_GAMES+1))
  #insert new n_games to database
  N_GAMES_UPDATE=$($PSQL "UPDATE users SET games_played=$N_GAMES WHERE username='$USERNAME'")
fi
echo "Guess the secret number between 1 and 1000:"
read GUESS_TEMP
while [[ ! $GUESS_TEMP =~ ^[0-9]+$ ]]
do 
  echo "That is not an integer, guess again:"
  read GUESS_TEMP
done
GUESS=$GUESS_TEMP
#initialize counter
COUNTER=1
while [[ $GUESS != $R_NUMBER ]]
do
if [[ $GUESS < $R_NUMBER ]]
then
  echo "It's higher than that, guess again:"
else
  echo "It's lower than that, guess again:"
fi
read GUESS_TEMP
while [[ ! $GUESS_TEMP =~ ^[0-9]+$ ]]
do 
  echo "That is not an integer, guess again:"
  read GUESS_TEMP
done
GUESS=$GUESS_TEMP
COUNTER=$(($COUNTER+1))
done
#set winning phrase
echo "You guessed it in $COUNTER tries. The secret number was $R_NUMBER. Nice job!"
#update database best guess
if [[ $COUNTER<$BEST_GAME ]]
then 
  UPDATE_BEST_GAME=$($PSQL "UPDATE users SET best_game=$COUNTER WHERE username='$USERNAME'")
fi