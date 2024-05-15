import pandas as pd
import sys
import mysql.connector
from mysql.connector import Error
from faker import Faker



# Create an instance of the Faker class
fake = Faker()

# Function to generate fake data for missing columns
def generate_fake_data(row):
    if row['order_id'] == '':
        row['order_id'] = fake.uuid4()
    if row['number_of_items']=='':
        row['number_of_items'] = fake.random_int(min=1, max=10)
    return row



# Connect to the MySQL database
try:
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

    
    if connection.is_connected():
        cursor = connection.cursor()

        # Read the CSV file into a pandas DataFrame
        df = pd.read_csv('new_fraud_modified.csv')
        df['order_id']=''
        df['number_of_items']=''
        # Apply the function to fill in missing data
        df = df.apply(generate_fake_data, axis=1)
        df['device_type'] = 'Android'
        # Insert data into the `device` table
        device_data = df[['device_id', 'browser', 'device_type','source']].drop_duplicates()
        device_data.reset_index(drop=True, inplace=True)
        for index, row in device_data.iterrows():
            cursor.execute("INSERT INTO device (DeviceID, Browser, DeviceType,source) VALUES (%s, %s, %s,%s)", (row['device_id'], row['browser'], row['device_type'],row['source']))
            connection.commit()
            print("inserted deviceRow with device_id:"+row['device_id'])
        # Get the device IDs
        cursor.execute("SELECT ID, DeviceID FROM device")
        device_ids = {row[1]: row[0] for row in cursor.fetchall()}

        # Insert data into the `geolocation` table
        geolocation_data = df[['ip_address', 'IP_country', 'device_id']].drop_duplicates()
        geolocation_data.reset_index(drop=True, inplace=True)
        for index, row in geolocation_data.iterrows():
            cursor.execute("INSERT INTO geolocation (IPAddress, Country, device_ID) VALUES (%s, %s, %s)", (row['ip_address'], row['IP_country'], device_ids.get(row['device_id'])))
            connection.commit()
            print("inserted geoLocationRow with device_id:"+str(device_ids.get(row['device_id'])))
        # Convert dates to MySQL format
        df['signup_time'] = pd.to_datetime(df['signup_time']).dt.strftime('%Y-%m-%d %H:%M:%S')
        df['purchase_time'] = pd.to_datetime(df['purchase_time']).dt.strftime('%Y-%m-%d %H:%M:%S')

        # Insert data into the `transactions` table
        transactions_data = df[['purchase_time', 'purchase_value', 'order_id', 'number_of_items', 'user_id', 'device_id', 'class', 'ip_address']].copy()
        transactions_data.rename(columns={'purchase_time': 'PurchaseTime', 'purchase_value': 'PurchaseValue', 'order_id': 'OrderID', 'number_of_items': 'NumberOfItems', 'user_id': 'UserID', 'device_id': 'DeviceID', 'class': 'Class', 'ip_address': 'IPAddress'}, inplace=True)
        transactions_data.reset_index(drop=True, inplace=True)
        for index, row in transactions_data.iterrows():
            cursor.execute("INSERT INTO transactions (PurchaseTime, PurchaseValue, OrderID, NumberOfItems, UserID, DeviceID, Class, geolocation_ID) VALUES (%s, %s, %s, %s, %s, %s, %s, (SELECT ID FROM geolocation WHERE IPAddress = %s))", (row['PurchaseTime'], row['PurchaseValue'], row['OrderID'], row['NumberOfItems'], row['UserID'], device_ids.get(row['DeviceID']), row['Class'], row['IPAddress']))
            connection.commit()
            print("inserted transactionRow with device_id:"+str(device_ids.get(row['DeviceID'])))


except Error as e:
    print("Error while connecting to MySQL", e)

finally:
    if (connection.is_connected()):
        cursor.close()
        connection.close()
        print("MySQL connection is closed")
        
