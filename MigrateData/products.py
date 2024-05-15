import pandas as pd
import numpy as np  # Import numpy library to handle NaN values
import json
# Load the JSON file
encodings = ['utf-8', 'latin-1', 'windows-1252']

for encoding in encodings:
    try:
        with open('amazon_uk_shoes_dataset.json', 'r', encoding=encoding) as json_file:
            products_data = json.load(json_file)
        print(f"Using encoding: {encoding}")
        break
    except UnicodeDecodeError:
        print(f"Failed to decode using encoding: {encoding}")

# Read the CSV file into a DataFrame
df = pd.read_csv('products.csv')
# Replace 'nan' values with None
df = df.where(pd.notnull(df), None)

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

# Iterate through each row in the DataFrame and insert data into the database
for index, row in df.iterrows():
    # Check if the URL from CSV matches any URL in the JSON data
    json_product = next((p for p in products_data if p['url'] == row['url']), None)
    if   json_product: 
        # Use the price and product details from the JSON data
        price = json_product['price']
        product_details = json_product['product_details']
    else:
        # Use the price and product details from the CSV data
        price = row['price']
        product_details = row['product_details']
    if row['price'] is None or row['product_details'] is None:
        continue
    # Insert data into 'brand' table
    brand_query = "INSERT INTO brand (Name) VALUES (%s)"
    brand_data = (row['brand'],)
    cursor.execute(brand_query, brand_data)
    brand_id = cursor.lastrowid

    # Insert data into 'breadcrumb' table
    breadcrumb_query = "INSERT INTO breadcrumb (Category) VALUES (%s)"
    breadcrumb_data = (row['breadcrumbs'],)
    cursor.execute(breadcrumb_query, breadcrumb_data)
    breadcrumb_id = cursor.lastrowid

    # Insert data into 'feature' table
    feature_query = "INSERT INTO feature (Details) VALUES (%s)"
    feature_data = (row['features'],)
    cursor.execute(feature_query, feature_data)
    feature_id = cursor.lastrowid

    # Insert data into 'product' table
    product_query = "INSERT INTO product (URL, Title, ASIN, Price, BrandID, ProductDetails, BreadcrumbID, FeatureID, malicious_url_ID) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)"
    product_data = (row['url'], row['title'], row['asin'], price, brand_id, product_details, breadcrumb_id, feature_id, None)  # Initially set malicious_url_ID to None
    cursor.execute(product_query, product_data)
    product_id = cursor.lastrowid

    # Insert data into 'content_moderation_record' table
    moderation_query = "INSERT INTO content_moderation_record (Location, HasCompanyLogo, HasQuestions, Industry, Fraudulent, ProductID) VALUES (%s, %s, %s, %s, %s, %s)"
    moderation_data = (row['location'], row['has_company_logo'], row['has_questions'], row['industry'], row['fraudulent'], product_id)
    cursor.execute(moderation_query, moderation_data)

    # Insert data into 'malicious_url' table
    malicious_url_query = "INSERT INTO malicious_url (url) VALUES (%s)"
    malicious_url_data = (row['url'],)
    cursor.execute(malicious_url_query, malicious_url_data)

    # Get the last inserted malicious_url ID
    malicious_url_id = cursor.lastrowid

    # Update the malicious_url_ID column in 'product' table with the corresponding malicious_url ID
    update_product_query = "UPDATE product SET malicious_url_ID = %s WHERE ID = %s"
    update_product_data = (malicious_url_id, product_id)
    cursor.execute(update_product_query, update_product_data)
    # Insert data into 'images' table

    if row['images_list']:
        images = row['images_list'].split(',')
        images[-1] = images[-1][:-1]
        for image_url in images:
            image_query = "INSERT INTO images (ImageURL, product_ID) VALUES (%s, %s)"
            image_url[2:-1]
            image_data = (image_url.strip(), product_id)
            cursor.execute(image_query, image_data)

# Commit the changes and close the connection
connection.commit()
connection.close()