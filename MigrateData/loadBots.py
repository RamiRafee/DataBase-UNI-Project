import pandas as pd
import mysql.connector
from datetime import datetime
import sys


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
# Establish a connection to the database

cursor = connection.cursor()

# Read data from the CSV file
df = pd.read_csv('ecommerce_human_bot.csv')
df_gender_age = pd.read_csv('new_fraud_modified.csv')[1:37437]

df['sex'] = df_gender_age['sex']
df['age'] = df_gender_age['age']
df = df.where(pd.notnull(df), None)[1:]

mean_age = df['age'].mean()
df['age'] = df['age'].fillna(mean_age)
# Iterate over each row in the DataFrame
for index, row in df.iterrows():
    user_lang = row['user_lang']
    username = row['username']
    user_sex=row['sex']
    user_age=row['age']

    # Set the password to '123'
    password = '123'

    # Insert the row into the 'user' table
    cursor.execute("INSERT INTO `user` (`UserLanguage`, `Username`, `Password`, `sex`, `isAdmin`, `age`) VALUES (%s, %s, %s, %s, %s, %s)",(user_lang, username, password, user_sex, 0, user_age))
    connection.commit()

    # Get the last insert ID
    cursor.execute("SELECT LAST_INSERT_ID()")
    user_id = cursor.fetchone()[0]

    # Insert into 'bot_behavior_record' table
    created_at = row['created_at']
    has_default_profile = 1 if row['has_default_profile'] else 0
    has_default_profile_img = 1 if row['has_default_profile_img'] else 0
    prod_fav_count = row['prod_fav_count']
    followers_count = row['followers_count']
    friends_count = row['friends_count']
    is_geo_enabled = 1 if row['is_geo_enabled'] else 0
    avg_purchases_per_day = row['avg_purchases_per_day']
    account_age = row['account_age']
    account_type = row['account_type']
    
    cursor.execute("INSERT INTO `bot_behavior_record` (`CreatedAt`, `HasDefaultProfile`, `HasDefaultProfileImage`, `prod_fav_count`, `FollowersCount`, `FriendsCount`, `IsGeoEnabled`, `UserID`, `AvgPurchasesPerDay`, `AccountAge`, `AccountType`) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", 
                   (created_at, has_default_profile, has_default_profile_img, prod_fav_count, followers_count, friends_count, is_geo_enabled, user_id, avg_purchases_per_day, account_age, account_type))
    connection.commit()

    # Insert into 'purchase_record' table
    purchase_count = row['purchase_count']
    purchase_date = datetime.now()
    
    cursor.execute("INSERT INTO `purchase_record` (`PurchaseCount`, `UserID`, `PurchaseDate`, `avg_purchases_per_day`) VALUES (%s, %s, %s, %s)", 
                   (purchase_count, user_id, purchase_date, avg_purchases_per_day))
    connection.commit()

# Close the cursor and connection
cursor.close()
connection.close()