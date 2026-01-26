#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != 'YEAR' ]]
  then
    if [[ $ROUND != 'round' ]]
    then
      if [[ $WINNER_GOALS != 'winner_goals' ]]
      then
        if [[ $OPPONENT_GOALS != 'opponent_goals' ]]
        then
          if [[ $WINNER != 'winner' ]]
          then
            #get winner team_id
            WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
            #if team_id
            if [[ -z $WINNER_ID ]]
            then
              #insert team into the teams table
              WINNER_ID_INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
              WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
            fi
            #I do the same thing with opponent id
            if [[ $OPPONENT != 'opponent' ]]
            then
              OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
              if [[ -z $OPPONENT_ID ]]
              then
                #insert team into the teams table
                OPPONENT_ID_INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
                OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
              fi
              #INSERT INTO THE TABLE THE VALUES FROM THE FILE
              INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
            fi
          fi
        fi
      fi
    fi
  fi

done