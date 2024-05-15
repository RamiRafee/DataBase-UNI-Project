#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <host> <user> <password> <database>"
    exit 1
fi

# Assign the arguments to variables
HOST=$1
USER=$2
PASSWORD=$3
DATABASE=$4

# Function to run Python script with verbose printing
run_script() {
    echo "Running $1..."
    python "$1" "$HOST" "$USER" "$PASSWORD" "$DATABASE"
}

# Drop and create a new database
echo "Dropping and recreating database $DATABASE ..."
mysql -h "$HOST" -u "$USER" -p"$PASSWORD" -e "DROP DATABASE IF EXISTS marcitest;"
mysql -h "$HOST" -u "$USER" -p"$PASSWORD" -e "CREATE DATABASE marcitest;"

# Import the SQL file into the new database
echo "Importing data from marciTest.sql into $DATABASE ..."
mysql -h "$HOST" -u "$USER" -p"$PASSWORD" "marcitest" < marciTest.sql

# Run Python scripts in order
run_script "malicious_url.py"
run_script "products.py"
run_script "Transactions.py"
run_script "loadBots.py"
run_script "update_membershipsubscription.py"