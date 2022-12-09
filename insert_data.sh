#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "truncate table teams,games")"

cat games.csv | while IFS=',' read Year Round Winner Opponent Winner_g Opponent_g
do
  TEAMS=$($PSQL "select name from teams where name='$Winner'")
  if [[ $Winner != "winner" ]]
  then
    if [[ -z $TEAMS ]]
    then
    INSERT_TEAMS=$($PSQL "insert into teams(name) values('$Winner')")
    if [[ $INSERT_TEAMS == 'INSERT 0 1' ]]
    then
    echo Inserted into teams,$Winner
    fi
    fi
  fi
  
  TEAMS2=$($PSQL "select name from teams where name='$Opponent'")
  if [[ $Opponent != "opponent" ]]
  then
    if [[ -z $TEAMS2 ]]
    then
    INSERT_TEAMS2=$($PSQL "insert into teams(name) values('$Opponent')")
    if [[ $INSERT_TEAMS2 == 'INSERT 0 1' ]]
    then
    echo Inserted into teams,$Opponent
    fi
    fi
  fi
  
  INSERT_TEAMID_W=$($PSQL "select team_id from teams where name='$Winner'")
  INSERT_TEAMID_O=$($PSQL "select team_id from teams where name='$Opponent'")
   
   if [[ -n INSERT_TEAMID_W || -n INSERT_TEAMID_O ]]
   then
      if [[ $Year != "year" ]]
      then
        INSERT_GAME=$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values('$Year','$Round','$INSERT_TEAMID_W','$INSERT_TEAMID_O','$Winner_g','$Opponent_g')")
        if [[ $INSERT_GAME == 'INSERT 0 1' ]]
        then
        echo inserted into games,$Year
        fi
      fi
   fi
done