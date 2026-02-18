#! /bin/bash

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  SERVICE_LIST=$(psql --username=freecodecamp --dbname=salon --tuples-only -c "SELECT service_id,name FROM services")
  echo "$SERVICE_LIST" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME" 
  done
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    [0-5]) SCHEDULER $SERVICE_ID_SELECTED ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac 
}

SCHEDULER(){
  echo -e "\nWhat's your phone number:"
  read CUSTOMER_PHONE
  #get customer id from database
  CUSTOMER_ID=$(psql --username=freecodecamp --dbname=salon --tuples-only -c "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  #if customer id not found
  if [[ -z $CUSTOMER_ID ]]
  then
    #ask for name
    echo -e "\nI see you are a new customer, welcome!\nCan you tell me your name?"
    read CUSTOMER_NAME
    #insert new customer entry into the database
    CUSTOMER_ID_RESULT=$(psql --username=freecodecamp --dbname=salon --tuples-only -c "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    #get the new customer_id
    CUSTOMER_ID=$(psql --username=freecodecamp --dbname=salon --tuples-only -c "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi
  echo -e "\nAt what time would you like to schedule your appointment?"
  read SERVICE_TIME
  #insert appointment into the database
  INSERT_APPOINTMENT_RESULT=$(psql --username=freecodecamp --dbname=salon --tuples-only -c "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  SERVICE_NAME=$(psql --username=freecodecamp --dbname=salon --tuples-only -c "SELECT name FROM services WHERE service_id=$1")
  #refresh customer name
  CUSTOMER_NAME=$(psql --username=freecodecamp --dbname=salon --tuples-only -c "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")
  echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
}

EXIT(){
  echo -e '\nThank you for stopping in.\n'
}


MAIN_MENU