#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

SEND_TEXT(){
if [[ -z $1  ]];then
    echo "I could not find that element in the database."
    else
    echo $1 | while read NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR MASS BAR MELTING BAR BOILING
      do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
fi
}

if [[ -z $1 ]]; then
echo "Please provide an element as an argument."
else
  if [[  $1 =~ ^[0-9]+$  ]]; then
  RESPONSE=$($PSQL "SELECT  atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements e LEFT JOIN properties p USING (atomic_number) WHERE atomic_number=$1")
    SEND_TEXT "$RESPONSE"

  else
  #Check for name
  RESPONSE=$($PSQL "SELECT  atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements e LEFT JOIN properties p USING (atomic_number) WHERE e.name='$1'")
    if [[ -z $RESPONSE ]]; then
      #Check for symbol
      RESPONSE=$($PSQL "SELECT  atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements e LEFT JOIN properties p USING (atomic_number) WHERE e.symbol='$1'")
      SEND_TEXT "$RESPONSE"
    else
      SEND_TEXT "$RESPONSE"
    fi


  fi

fi