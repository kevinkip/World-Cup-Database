#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINS LOSSES
do
  if [[ $WINNER != "winner" ]]
  then
    WINNER_ID=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")

      if [[ -z $WINNER_ID ]]
      then
        # insert year
        INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
        then
          echo Inserted into teams, $WINNER 
        fi
        WINNER_ID=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
      fi
    OPPONENT_ID=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    # if not found 
    if [[ -z $OPPONENT_ID ]]
    then
      # insert opponent into teams name
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
      OPPONENT_ID=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINS LOSSES
do
  if [[ $YEAR != "year" ]]
  then
    YEAR_ID=$($PSQL "SELECT year FROM games WHERE year='$YEAR'")
    if [[ -z $YEAR ]]
    then
      YEAR_ID=null
    fi
    ROUND_ID=$($PSQL "SELECT round FROM games WHERE round='$ROUND'")
    if [[ -z $ROUND ]]
    then
      ROUND_ID=null
    fi
    WINS_ID=$($PSQL "SELECT winner_goals FROM games WHERE winner_goals='$WINS'")
    if [[ -z $WINS ]]
    then
      WINS_ID=null
    fi

    LOSSES_ID=$($PSQL "SELECT opponent_goals FROM games WHERE opponent_goals='$LOSSES'")
    if [[ -z $LOSSES ]]
    then
      LOSSES_ID=null
    fi
    WINNING_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    LOSING_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNING_TEAM_ID, $LOSING_TEAM_ID, $WINS, $LOSSES)")
    if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into games, $YEAR $ROUND $WINNING_TEAM_ID $LOSING_TEAM_ID $WINS $LOSSES
    fi
  fi
done

# year
# round
# winner_goals
# opponent_goals