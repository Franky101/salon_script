#!/bin/bash


PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon Appointment App ~~~~~\n"

MENU () {
  if [[ $1 ]]
  then
    echo -e "\n$1\n"
  else
    echo -e "Welcome to My Super Salon Deluxe, how can I help you?" 
  fi
  
  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  
  # echo -e "\n1) cut\n2) dye\n3) permanent\n4) Exit"

  # ask for service to use
  read SERVICE_ID_SELECTED


  : '
  # if input is not a number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    MENU "I could not find that service. What would you like today?"
  fi
  '
  case $SERVICE_ID_SELECTED in
    1) CUT ;;
    2) DYE ;;
    3) PERMANENT ;;
    4) EXIT ;;
    *) MENU "Please enter a valid option." ;;
  esac
}
CUT() {
# get customer info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    # insert new customer with phone
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
    
  fi

  # get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  

  # get service name
  SERVICE_INFO=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  #Create new format of reads
  SERVICE_FORMATTED=$(echo $SERVICE_INFO | sed -r 's/^ *| *$//g')
  CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')
 
  # get time for the appointment
  echo -e "\nWhat time would you like your $SERVICE_FORMATTED, $CUSTOMER_NAME_FORMATTED?"
  read SERVICE_TIME

  # insert appointment 
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  # send to main menu
  echo -e "\nI have put you down for a $SERVICE_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME_FORMATTED."

}
DYE() {
  # get customer info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    # insert new customer with phone
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
    
  fi

  # get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  

  # get service name
  SERVICE_INFO=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  #Create new format of reads
  SERVICE_FORMATTED=$(echo $SERVICE_INFO | sed -r 's/^ *| *$//g')
  CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')
 
  # get time for the appointment
  echo -e "\nWhat time would you like your $SERVICE_FORMATTED, $CUSTOMER_NAME_FORMATTED?"
  read SERVICE_TIME

  # insert appointment 
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  # send to main menu
  echo -e "\nI have put you down for a $SERVICE_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME_FORMATTED."

}
PERMANENT() {
  # get customer info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    # insert new customer with phone
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
    
  fi

  # get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  

  # get service name
  SERVICE_INFO=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  #Create new format of reads
  SERVICE_FORMATTED=$(echo $SERVICE_INFO | sed -r 's/^ *| *$//g')
  CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')
 
  # get time for the appointment
  echo -e "\nWhat time would you like your $SERVICE_FORMATTED, $CUSTOMER_NAME_FORMATTED?"
  read SERVICE_TIME

  # insert appointment 
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  # send to main menu
  echo -e "\nI have put you down for a $SERVICE_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME_FORMATTED."

}

:'
EXIT() {
  echo -e "\nThank you for stopping in.\n"
}
'
MENU
