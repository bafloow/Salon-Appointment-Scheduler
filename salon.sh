#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
  echo -e "\n$1"
  fi
  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo  "Welcome to my salon, how can I help you?"
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
echo -e "\n$SERVICE_ID) $SERVICE_NAME"
done
read SERVICE_ID_SELECTED
SERVICE_ID=$($PSQL "SELECT service_id FROM services")
case $SERVICE_ID_SELECTED in
1) SERVICE_MENU ;;
2) SERVICE_MENU ;;
3) SERVICE_MENU ;;
4) SERVICE_MENU ;;
5) SERVICE_MENU ;;
*) MAIN_MENU "Please enter valid option" ;;
esac
}

SERVICE_MENU() {
  #get customer phone
  echo -e "\nPlease enter your phone number"
  read CUSTOMER_PHONE
  
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  
  # if customer doesnt exist
  if [[ -z $CUSTOMER_NAME ]]
  then
  # get new customer name
  echo -e "\nWhat's your name?"
  read CUSTOMER_NAME

  #insert new customer 
  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  # get time of the appointment
  echo -e "\nWhen do you want to take our service?"
  read SERVICE_TIME
  CUSTOMERS=$($PSQL "SELECT customer_id, name, phone FROM customers")
  echo "$CUSTOMERS" | while read CUSTOMER_ID BAR CUSTOMER_NAME BAR CUSTOMER_PHONE
  do
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, time, service_id) VALUES ('$CUSTOMER_ID','$SERVICE_TIME','$SERVICE_ID_SELECTED')")

  done
   SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
      echo I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME.

}
MAIN_MENU