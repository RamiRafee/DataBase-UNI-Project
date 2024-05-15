import csv
import sys
import mysql.connector

# Extract database arguments from command-line arguments
if len(sys.argv) != 5:
    print("Usage: python script_name.py <host> <user> <password> <database>")
    sys.exit(1)

host = sys.argv[1]
user = sys.argv[2]
password = sys.argv[3]
database = sys.argv[4]

# Establish a connection to the database
try:
    connection = mysql.connector.connect(
        host=host,
        user=user,
        password=password,
        database=database
    )
    print("Connected to database successfully.")
except mysql.connector.Error as e:
    print(f"Error connecting to database: {e}")
    sys.exit(1)

cursor = connection.cursor()

# Read data from malicious_phish.csv and insert into malicious_url table
with open('malicious_phish.csv', 'r', encoding='utf-8') as csvfile:
    csvreader = csv.reader(csvfile)
    next(csvreader)  # Skip header row
    for row in csvreader:
        url, url_type = row
        # Insert data into 'malicious_url' table
        malicious_url_query = "INSERT INTO malicious_url (url, Type) VALUES (%s, %s)"
        malicious_url_data = (url, url_type)
        cursor.execute(malicious_url_query, malicious_url_data)

# Commit changes and close connection
connection.commit()
connection.close()
