#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# if there is no argument given
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."

# if atomic number is given as argument
elif [[ $1 =~ ^[0-9]+$ ]]
then 
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM ELEMENTS WHERE ATOMIC_NUMBER=$1")
  if [[ $ATOMIC_NUMBER ]]
  then
    DETAILS=$($PSQL "select e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type from elements e join properties p using(atomic_number) join types t using(type_id) where e.atomic_number=$ATOMIC_NUMBER")
    echo "$DETAILS" | while IFS='|' read SYMBOL NAME ATOMIC_MASS MELTING BOILING TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  else
    echo "I could not find that element in the database."
  fi
  
# if element symbol is given as argument
elif [[ $1 =~ ^[A-Z,a-z]{0,2}$ ]]
then 
  SYMBOL=$($PSQL "SELECT SYMBOL FROM ELEMENTS WHERE SYMBOL='$1'")
  if [[ $SYMBOL ]]
  then 
    DETAILS=$($PSQL "select e.atomic_number, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type from elements e join properties p using(atomic_number) join types t using(type_id) where e.symbol='$SYMBOL'")
    echo "$DETAILS" | while IFS='|' read ATOMIC_NUMBER NAME ATOMIC_MASS MELTING BOILING TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  else
    echo "I could not find that element in the database."
  fi

# if name is given as argument
else 
  NAME=$($PSQL "SELECT name FROM ELEMENTS WHERE name='$1'")
  if [[ $NAME ]]
  then 
    DETAILS=$($PSQL "select e.atomic_number, e.symbol, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type from elements e join properties p using(atomic_number) join types t using(type_id) where e.name='$NAME'")
    echo "$DETAILS" | while IFS='|' read ATOMIC_NUMBER SYMBOL ATOMIC_MASS MELTING BOILING TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  else
    echo "I could not find that element in the database."
  fi
fi
