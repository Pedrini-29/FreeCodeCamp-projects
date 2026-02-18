#!/bin/bash

#shortcut call to database connection functionality
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align --tuples-only -c"

#check if an argument has been typed
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
  #check if element number is 
#elif [[ -z echo $($PSQL "SELECT * FROM elements WHERE symbol=$1") ]]
#then
else
  #check if argument is a symbol
  if [[ -z $(echo $($PSQL "SELECT * FROM elements WHERE symbol='$1'")) ]]
  then
  #check if argument is a name
    if [[ -z $(echo $($PSQL "SELECT * FROM elements WHERE name='$1'")) ]]
    then
      #check if argument is an atomic number
      if [[ -z $(echo $($PSQL "SELECT * FROM elements WHERE atomic_number='$1'")) ]]
      then
        echo I could not find that element in the database.
      else
        #get values from databse
        RESULT=$($PSQL "SELECT atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number='$1'")
        #read values to respective variables
        IFS='|' read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS <<< $RESULT
        #print exit string
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      fi
    else
      #get values from databse
      RESULT=$($PSQL "SELECT atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name='$1'")
      #read values to respective variables
      IFS='|' read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS <<< $RESULT
      #print exit string
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    fi
  else
    #get values from databse
    RESULT=$($PSQL "SELECT atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol='$1'")
    #read values to respective variables
    IFS='|' read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS <<< $RESULT
    #print exit string
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius." 
  fi
fi



