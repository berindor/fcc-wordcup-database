#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# delete all data from the tables
DELETE_RESULT=$($PSQL "TRUNCATE TABLE games, teams")
# read data from line
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# if it is not the first line 
 if (( $YEAR != year ))
 then 
 # insert team data: 
 # search for team name in teams
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  # if team name is not present
  if [[ -z "$WINNER_ID" ]]
  then
   # insert team name into teams 
   NAME_INSERT_RESULT=$($PSQL "INSERT INTO teams (name) VALUES('$WINNER')")
   # read team_id 
   WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  fi

# repeat with the other team! 
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  if [[ -z "$OPPONENT_ID" ]]
  then
   NAME_INSERT_RESULT=$($PSQL "INSERT INTO teams (name) VALUES('$OPPONENT')")
   OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  fi

# insert games data
  INSERTED_DATA=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
 fi
done