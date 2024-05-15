import pandas as pd
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
db_cursor = connection.cursor()

# Read the CSV file into a pandas DataFrame
csv_file_path = "ecommerce_human_bot.csv"
data = pd.read_csv(csv_file_path)

# Iterate over the rows and update the MySQL database
for index, row in data.iterrows():
    id = index + 1  # Assuming the ID in the database starts from 1
    membership_subscription = row["membership / subscription"]
    
    # Update the database row
    update_query = "UPDATE bot_behavior_record SET MembershipSubscription = %s WHERE ID = %s"
    db_cursor.execute(update_query, (membership_subscription, id))
    connection.commit()
    print("Row"+str(id) +" Has Been Updated")

# Close the database connection
db_cursor.close()
connection.close()