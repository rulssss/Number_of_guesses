#!/bin/bash
 
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# generate random number

SECRET_NUMBER=$((RANDOM %1000 + 1))
echo "RANDOM.. $SECRET_NUMBER"
# get username

echo "Enter your username:"
read USERNAME

# variables 

SEARCH_USERNAME=$($PSQL "SELECT username FROM guesses WHERE username = '$USERNAME'")
GAMES_PLAYED=$($PSQL "SELECT games_played FROM guesses WHERE username = '$USERNAME'")
BEST_GAME=$($PSQL "SELECT best_game FROM guesses WHERE username = '$USERNAME'")

# username verification

if [[ -z $SEARCH_USERNAME ]]
then
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."

  INSERT_USERNAME=$($PSQL "INSERT INTO guesses(username, games_played, best_game) VALUES('$USERNAME', $(( RANDOM %9 + 1 )), $((RANDOM %10 + 1)))")

else
  echo -e "\nWelcome back, $SEARCH_USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi


# function

SECRET_FUNCTION_VERIF(){
  if [[ ! $NUMBER =~ ^[0-9]+$ ]]
  then
    while [[ ! $NUMBER =~ ^[0-9]+$ ]]
    do
      echo -e "\nThat is not an integer, guess again:"
      read NUMBER
    done
  fi
 

}

# put guess´ secret number 

echo -e "\nGuess the secret number between 1 and 1000:"
read NUMBER
SECRET_FUNCTION_VERIF

NUMBER_OF_GUESSES=0

while [[ $NUMBER != $SECRET_NUMBER ]] 
do
  NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES+1))

  if [[ $SECRET_NUMBER < $NUMBER ]]
  then
    echo -e "\nIt's lower than that, guess again:"
    read NUMBER
    SECRET_FUNCTION_VERIF

  else
    echo -e "\nIt's higher than that, guess again:"
    read NUMBER
    SECRET_FUNCTION_VERIF

  fi
  
done

echo -e "\nYou guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

