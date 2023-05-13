#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
# Check whether user has attempted to run the script without arguments
if [[ -z $1 ]]
then
	#If yes, then provide a message and exit the programme
	echo "Please provide an element as an argument."
else
	#If user has provided an input, then we need to check this against the periodic_table database, 
	#using the input as a possible match for the atomic number, the symbol or the element name
	#First need to check whether the input variable is a number or a character
	if [[ $1 =~ ^[0-9]+$ ]]
	then
		ATOM_DATA=$($PSQL "SELECT el.name,el.atomic_number,el.symbol,t.type,pr.atomic_mass,pr.melting_point_celsius,pr.boiling_point_celsius FROM elements el INNER JOIN properties pr ON el.atomic_number = pr.atomic_number INNER JOIN types t ON pr.type_id = t.type_id WHERE el.atomic_number = $1")
	else
		ATOM_DATA=$($PSQL "SELECT el.name,el.atomic_number,el.symbol,t.type,pr.atomic_mass,pr.melting_point_celsius,pr.boiling_point_celsius FROM elements el INNER JOIN properties pr ON el.atomic_number = pr.atomic_number INNER JOIN types t ON pr.type_id = t.type_id WHERE el.name = '$1' OR el.symbol = '$1'")
	fi
	#Check whether the SQL query returned any values
	if [[ -z $ATOM_DATA ]]
	then
		#If query returns no value then exit the programme.
		echo "I could not find that element in the database."
	else
		#If query does return a value, then read this into other variables and pass the information out to the user in the form of a formatted message, then exit the programme.
		echo $ATOM_DATA | while read ELEMENT_NAME BAR ATOMIC_NUMBER BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
		do
			echo -e "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
		done
	fi
fi