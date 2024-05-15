<?php
// Establish a connection to the database
$servername = "localhost";
$username = "hassan";
$password = "hassanroot";
$dbname = "marcitest";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Expose-Headers: Custom-Header");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");

// Define the function to send POST request
function sendPostRequest($url, $data)
{
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));
    $response = curl_exec($ch);
    curl_close($ch);
    return $response;
}

// Define the endpoints
$contentModerationEndpoint = 'http://localhost:5000/contentModeration';
$externalUrlEndpoint = 'http://localhost:5000/externalUrl';
$transactionFraudEndpoint = 'http://localhost:5000/transaction';
$botDetectionEndpoint = 'http://localhost:5000/detect_bots_batch';

// Check if the GET request is sent and action is specified
if ($_SERVER["REQUEST_METHOD"] == "GET" && isset($_GET["action"])) {
    $action = $_GET["action"];

    switch ($action) {
        case "brand_search":
            // Get the search term from the query parameters
            $search_term = $_GET["brand"];

            // Prepare SQL statement to search for brands
            $sql = "SELECT DISTINCT Name FROM brand WHERE Name LIKE '$search_term%'";
            $result = $conn->query($sql);

            // Check if there are any matching brands
            if ($result->num_rows > 0) {
                // Store the matching brand names in an array
                $brands = array();
                while ($row = $result->fetch_assoc()) {
                    $brands[] = $row["Name"];
                }

                // Return the list of matching brand names as JSON response
                echo json_encode(array('search' => $brands));
            } else {
                // If no matching brands found, return empty array as JSON response
                echo json_encode(array());
            }
            break;
        case "landing_page":
            // Prepare SQL statement to retrieve 50 products with priority to newest ones
            $sql = "SELECT p.ID, p.Title, p.Price, p.URL, p.ASIN, GROUP_CONCAT(i.ImageURL) AS ImageURLs
            FROM product p
            INNER JOIN images i ON p.ID = i.product_ID
            LEFT JOIN content_moderation_record cmr ON p.ID = cmr.ProductID
            LEFT JOIN malicious_url mu ON p.malicious_url_ID = mu.id
            WHERE (cmr.Fraudulent = 0 OR cmr.Fraudulent IS NULL) AND (mu.Type = 0 OR mu.Type IS NULL)
            GROUP BY p.ID, p.Title, p.Price, p.URL, p.ASIN
            ORDER BY p.ID DESC
            LIMIT 50";
            $result = $conn->query($sql);

            // Check if there are any products
            if ($result->num_rows > 0) {
                // Store the products in an array
                $products = array();
                while ($row = $result->fetch_assoc()) {
                    // Split the concatenated ImageURLs into an array
                    $imageURLs = explode(',', $row['ImageURLs']);
                    // Remove duplicates if any
                    $imageURLs = array_unique($imageURLs);
                    // Add the images array to the row
                    $row['ImageURLs'] = $imageURLs;
                    // Add the row to products array
                    $products[] = $row;
                }

                // Return the list of products as JSON response
                echo json_encode(array('landing_product' => $products));
            } else {
                // If no products found, return empty array as JSON response
                echo json_encode(array());
            }
            break;
        case "brands":
            // Prepare SQL statement to retrieve unique brand names
            $sql = "SELECT DISTINCT ID, Name FROM brand LIMIT 50";
            $result = $conn->query($sql);

            // Check if there are any unique brand names
            if ($result->num_rows > 0) {
                // Store the unique brand names in an array
                $brands = array();
                while ($row = $result->fetch_assoc()) {
                    $brands[] = $row["Name"];
                }

                // Return the list of unique brand names as JSON response
                echo json_encode(array('search' => $brands));
            } else {
                // If no unique brand names found, return empty array as JSON response
                echo json_encode(array());
            }
            break;
        case "products_by_brand":
            // Check if brand_name parameter is provided
            if (isset($_GET["brand_name"])) {
                $brand_name = $_GET["brand_name"];

                // Prepare SQL statement to retrieve BrandID for the given brand name
                $sql_brand_id = "SELECT ID FROM brand WHERE Name = '$brand_name'";
                $result_brand_id = $conn->query($sql_brand_id);

                // Check if the brand exists
                if ($result_brand_id->num_rows > 0) {
                    $row_brand_id = $result_brand_id->fetch_assoc();
                    $brand_id = $row_brand_id["ID"];

                    // Prepare SQL statement to retrieve products with the given BrandID
                    $sql_products = "SELECT p.ID, p.Title, p.Price, p.URL, p.ASIN, GROUP_CONCAT(i.ImageURL) AS ImageURLs
                    FROM product p
                    INNER JOIN images i ON p.ID = i.product_ID
                    LEFT JOIN content_moderation_record cmr ON p.ID = cmr.ProductID
                    LEFT JOIN malicious_url mu ON p.malicious_url_ID = mu.id
                    WHERE p.BrandID = '$brand_id' AND (cmr.Fraudulent = 0 OR cmr.Fraudulent IS NULL) AND (mu.Type = 0 OR mu.Type IS NULL)
                    GROUP BY p.ID, p.Title, p.Price, p.URL, p.ASIN
                    ORDER BY p.ID DESC
                    LIMIT 50";

                    $result_products = $conn->query($sql_products);

                    // Check if there are any products
                    if ($result_products->num_rows > 0) {
                        // Store the products in an array
                        $products = array();
                        while ($row_product = $result_products->fetch_assoc()) {
                            $imageURLs = explode(',', $row_product['ImageURLs']);
                            // Remove duplicates if any
                            $imageURLs = array_unique($imageURLs);
                            // Add the images array to the row
                            $row_product['ImageURLs'] = $imageURLs;
                            // Add the row to products array
                            $products[] = $row_product;
                        }

                        // Return the list of products as JSON response
                        echo json_encode(array('landing_product' => $products));
                    } else {
                        // If no products found for the brand, return empty array as JSON response
                        echo json_encode(array());
                    }
                } else {
                    // If the brand does not exist, return error message
                    echo json_encode(array("error" => "Brand not found"));
                }
            } else {
                // If brand_name parameter is not provided, return error message
                echo json_encode(array("error" => "Brand name not provided"));
            }
            break;
        case "product":
            // Check if ASIN is provided
            if (isset($_GET["asin"])) {
                $asin = $_GET["asin"];

                // Prepare SQL statement to search for the product using ASIN
                $sql = "SELECT p.ID, p.Title, p.ASIN, p.Price, p.ProductDetails, GROUP_CONCAT(i.ImageURL) AS ImageURLs, b.Name AS BrandName, b.ID AS BrandID, bc.Category, f.Details AS FeatureDetails, i.ImageURL
                FROM product p
                INNER JOIN breadcrumb bc ON p.BreadcrumbID = bc.ID
                INNER JOIN brand b ON p.BrandID = b.ID
                INNER JOIN feature f ON p.FeatureID = f.ID
                INNER JOIN images i ON p.ID = i.product_ID
                LEFT JOIN content_moderation_record cmr ON p.ID = cmr.ProductID
                LEFT JOIN malicious_url mu ON p.malicious_url_ID = mu.id
                WHERE p.ASIN = '$asin' AND (cmr.Fraudulent = 0 OR cmr.Fraudulent IS NULL) AND (mu.Type = 0 OR mu.Type IS NULL)";

                $result = $conn->query($sql);

                // Check if the product is found
                if ($result->num_rows > 0) {
                    // Fetch the product details
                    $product = $result->fetch_assoc();
                    $imageURLs = explode(',', $product['ImageURLs']);
                    // Remove duplicates if any
                    $imageURLs = array_unique($imageURLs);
                    // Add the images array to the row
                    $product['ImageURLs'] = $imageURLs;
                    // Return the product details as JSON response
                    echo json_encode($product);
                } else {
                    // If the product is not found, return an empty array as JSON response
                    echo json_encode(array());
                }
            } else {
                // If ASIN is not provided, return error message
                echo json_encode(array("error" => "ASIN not provided"));
            }
            break;

            case "admin_fraud_products":
                // Prepare SQL statement to retrieve 50 products with priority to newest ones
                $sql = "SELECT p.ID, p.Title, p.Price, p.URL, p.ASIN, GROUP_CONCAT(i.ImageURL) AS ImageURLs,
                CASE WHEN cmr.Fraudulent = 1 THEN '1' ELSE '0' END AS FraudulentProductMark,
                CASE WHEN mu.Type = 1 THEN '1' ELSE '0' END AS MaliciousURLMark
            FROM product p
            INNER JOIN images i ON p.ID = i.product_ID
            LEFT JOIN content_moderation_record cmr ON p.ID = cmr.ProductID
            LEFT JOIN malicious_url mu ON p.malicious_url_ID = mu.id
            WHERE cmr.Fraudulent = 1 OR mu.Type = 1
            GROUP BY p.ID, p.Title, p.Price, p.URL, p.ASIN, cmr.Fraudulent, mu.Type
            ORDER BY p.ID DESC
            LIMIT 50";
                $result = $conn->query($sql);
    
                // Check if there are any products
                if ($result->num_rows > 0) {
                    // Store the products in an array
                    $products = array();
                    while ($row = $result->fetch_assoc()) {
                        // Split the concatenated ImageURLs into an array
                        $imageURLs = explode(',', $row['ImageURLs']);
                        // Remove duplicates if any
                        $imageURLs = array_unique($imageURLs);
                        // Add the images array to the row
                        $row['ImageURLs'] = $imageURLs;
                        // Add the row to products array
                        $products[] = $row;
                    }
    
                    // Return the list of products as JSON response
                    echo json_encode(array('fraudulent_products' => $products));
                } else {
                    // If no products found, return empty array as JSON response
                    echo json_encode(array('error' => 'No fraudulent products found.'));
                }
                break;
        default:
            // If the action is not specified or invalid, return error message
            echo json_encode(array("error" => "Invalid action"));
            break;
    }
}
// Check if the POST request is sent and action is specified
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["action"])) {
    $action = $_POST["action"];

    switch ($action) {
        case "login":
            // Extract data from the POST request
            $username = $_POST['Username'];
            $password = $_POST['Password'];

            // Query to check if the username and password match
            $sql = "SELECT * FROM user WHERE Username = '$username' AND Password = '$password'";
            $result = $conn->query($sql);

            if ($result->num_rows > 0) {
                // User found, retrieve user ID
                $row = $result->fetch_assoc();
                $userID = $row['ID'];

                // Prepare success response
                $response = array(
                    "success" => true,
                    "userID" => $userID
                );
            } else {
                // User not found or incorrect password
                $response = array(
                    "success" => false,
                    "message" => "Invalid username or password"
                );
            }
            echo json_encode($response);
            break;
        case "add_user":
            $conn->autocommit(FALSE);

            try {
                // Start transaction
                $conn->begin_transaction();

                // Extract data from the POST request
                $user_lang = $_POST['user_lang'];
                $username = $_POST['username'];
                $password = $_POST['password'];
                $isAdmin = isset($_POST['isAdmin']) ? $_POST['isAdmin'] : 0;
                $created_at = date("m/d/Y H:i");
                $has_default_profile = $_POST['has_default_profile'];
                $has_default_profile_img = $_POST['has_default_profile_img'];
                $is_geo_enabled = $_POST['is_geo_enabled'];
                $membership_subscription = $_POST['membership_subscription'];

                // hi dawod
                $sex = $_POST['sex'];
                $age = $_POST['age'];



                ////////////////ignore the rest daowd/////////////////////
                $account_type = isset($_POST['account_type']) ? $_POST['account_type'] : "Not Determined";
                $followers_count = isset($_POST['followers_count']) ? $_POST['followers_count'] : 0;
                $friends_count = isset($_POST['friends_count']) ? $_POST['friends_count'] : 0;
                $avg_purchases_per_day = isset($_POST['avg_purchases_per_day']) ? $_POST['avg_purchases_per_day'] : 0;
                $account_age = isset($_POST['account_age']) ? $_POST['account_age'] : 0;
                $prod_fav_count = isset($_POST['prod_fav_count']) ? $_POST['prod_fav_count'] : 0;

                // Insert data into the 'user' table
                $sql = "INSERT INTO user (UserLanguage, Username, Password, isAdmin, sex, age) 
                VALUES ('$user_lang', '$username', '$password', '$isAdmin', '$sex', '$age')";
                if ($conn->query($sql) === TRUE) {
                    $user_id = $conn->insert_id; // Get the ID of the inserted user

                    // Insert data into the 'bot_behavior_record' table
                    $sql = "INSERT INTO bot_behavior_record (CreatedAt, HasDefaultProfile, HasDefaultProfileImage, FollowersCount, FriendsCount, IsGeoEnabled, MembershipSubscription, AvgPurchasesPerDay, AccountAge, AccountType, UserID, prod_fav_count) 
                    VALUES ('$created_at', '$has_default_profile', '$has_default_profile_img', '$followers_count', '$friends_count', '$is_geo_enabled', '$membership_subscription', '$avg_purchases_per_day', '$account_age', '$account_type', '$user_id', '$prod_fav_count')";
                    if ($conn->query($sql) === TRUE) {

                    } else {
                        throw new Exception("Error adding bot behavior record: " . $conn->error);
                    }
                } else {
                    throw new Exception("Error adding user: " . $conn->error);
                }
                echo json_encode(
                    array(
                        "message" => "New record created successfully",
                        "success" => true
                    )
                );
                // Commit transaction
                $conn->commit();
            } catch (Exception $e) {
                // Rollback transaction
                $conn->rollback();
                $response = array(
                    "message" => $e->getMessage(),
                    "success" => false,
                );
                echo json_encode($response);
            }
            break;
        case "add_product":
            // Extract data from the POST request
            $title = $_POST['title'];
            $asin = $_POST['asin'];
            $price = $_POST['price'];
            $brand_name = $_POST['brand_name'];
            $category = $_POST['category'];
            $product_details = $_POST['product_details'];
            $feature_details = $_POST['feature_details'];
            $malicious_url = $_POST['malicious_url'];
            $image_url = $_POST['image_url'];
            $location = $_POST['location'];
            $has_company_logo = $_POST['has_company_logo'];
            $has_questions = $_POST['has_questions'];
            $industry = $_POST['industry'];



            $url = "$based_url/product?asin=$asin";

            // Extract data from the POST request
            $title = $_POST['title'];
            $asin = $_POST['asin'];
            // Extract other fields similarly...

            // Prepare data for externalUrl endpoint
            $maliciousUrl = $_POST['malicious_url'];
            $responseExternalUrl = sendPostRequest($externalUrlEndpoint, json_encode(['url' => $maliciousUrl]));

            // Prepare data for contentModeration endpoint
            $dataContentModeration = array(
                'data' => array(
                    array(
                        'url' => $url,
                        'title' => $title,
                        'asin' => $asin,
                        'brand' => $brand_name,
                        'breadcrumbs' => $category,
                        'features' => $feature_details,
                        'location' => $location,
                        'has_company_logo' => $has_company_logo,
                        'has_questions' => $has_questions,
                        'industry' => $industry,
                    )
                )
            );

            $responseContentModeration = sendPostRequest($contentModerationEndpoint, json_encode($dataContentModeration));

            // Handle responses
            $externalUrlResponse = json_decode($responseExternalUrl, true);
            $contentModerationResponse = json_decode($responseContentModeration, true);

            // Handle the responses as needed
            // For example, you can print or store them
            //var_dump($externalUrlResponse);
            //var_dump($contentModerationResponse);
            // Check if the response contains the required fields
            if (isset($externalUrlResponse['predicted_type']) && isset($contentModerationResponse['predictions'])) {
                // Extract data from the response
                $predicted_type = $externalUrlResponse['predicted_type'];
                $best_model_prediction = $contentModerationResponse['predictions']['best_model_prediction'];

                //echo $predicted_type;
                //echo $best_model_prediction;

                // Map predicted_type to numerical values
                $type_mapping = array(
                    'benign' => 0,
                    'defacement' => 1,
                    'malware' => 2,
                    'phishing' => 3
                );
                // Map best_model_prediction to numerical values
                $fraudulent_mapping = array(
                    'not fraudulent' => 0,
                    'fraudulent' => 1
                );

                $type = $type_mapping[$predicted_type];
                $fraudulent = $fraudulent_mapping[$best_model_prediction];

                // echo $type;
                // echo $fraudulent;

                // Insert data into the 'feature' table
                $sql = "INSERT INTO feature (Details) VALUES ('$feature_details')";
                $conn->query($sql);
                $feature_id = $conn->insert_id;

                // Insert data into the 'malicious_url' table
                $sql = "INSERT INTO malicious_url (url, Type) VALUES ('$malicious_url', '$type')";
                $conn->query($sql);
                $malicious_url_id = $conn->insert_id;

                // Get BrandID from 'brand' table
                $sql = "SELECT ID FROM brand WHERE Name = '$brand_name'";
                $result = $conn->query($sql);

                if ($result->num_rows > 0) {
                    // If a match is found, fetch the ID
                    $row = $result->fetch_assoc();
                    $brand_id = $row['ID'];
                } else {
                    // If no match is found, insert the new brand name
                    $insert_sql = "INSERT INTO brand (Name) VALUES ('$brand_name')";
                    if ($conn->query($insert_sql) === TRUE) {
                        // Retrieve the auto-generated ID
                        $brand_id = $conn->insert_id;
                    } else {
                        echo "Error inserting new brand: " . $conn->error;
                        // Handle error case appropriately
                    }
                }
                // Get BreadcrumbID from 'breadcrumb' table
                $sql = "SELECT ID FROM breadcrumb WHERE Category = '$category'";
                $result = $conn->query($sql);

                if ($result->num_rows > 0) {
                    // If a match is found, fetch the ID
                    $row = $result->fetch_assoc();
                    $breadcrumb_id = $row['ID'];
                } else {
                    // If no match is found, insert the new brand name
                    $insert_sql = "INSERT INTO breadcrumb (Category) VALUES ('$category')";
                    if ($conn->query($insert_sql) === TRUE) {
                        // Retrieve the auto-generated ID
                        $breadcrumb_id = $conn->insert_id;
                    } else {
                        echo json_encode("Error inserting new category: " . $conn->error);
                        // Handle error case appropriately
                    }
                }
                // Insert data into the 'product' table
                $sql = "INSERT INTO product (URL, Title, ASIN, Price, BrandID, ProductDetails, BreadcrumbID, FeatureID, malicious_url_ID) 
                        VALUES ('$url', '$title', '$asin', '$price', '$brand_id', '$product_details', '$breadcrumb_id', '$feature_id', '$malicious_url_id')";
                if ($conn->query($sql) === TRUE) {
                    $product_id = $conn->insert_id; // Get the ID of the inserted product

                    // Insert data into the 'content_moderation_record' table
                    $sql = "INSERT INTO content_moderation_record (Location, HasCompanyLogo, HasQuestions, Industry, ProductID, Fraudulent) 
                        VALUES ('$location', '$has_company_logo', '$has_questions', '$industry', '$product_id', '$fraudulent')";
                    $conn->query($sql);

                    // Insert data into the 'images' table
                    $sql = "INSERT INTO images (ImageURL, product_ID) 
                        VALUES ('$image_url', '$product_id')";
                    $conn->query($sql);

                    // Check if both $type and $fraudulent are 0 (indicating success)
                    if ($type == 0 && $fraudulent == 0) {
                        // Success message
                        $response = array(
                            'status' => 'success',
                            'message' => 'New product added successfully',
                            'url' => $externalUrlResponse,
                            'content_moderation' => $contentModerationResponse
                        );
                    } else {
                        // Prepare error message
                        $errors = [];
                        if ($type != 0) {
                            $errors[] = 'External URL is invalid';
                        }
                        if ($fraudulent != 0) {
                            $errors[] = 'Product is invalid';
                        }
                        $error_message = 'Error: ' . implode(', ', $errors);

                        // Error message
                        $response = array(
                            'status' => 'error',
                            'message' => $error_message,
                            'url' => $externalUrlResponse,
                            'content_moderation' => $contentModerationResponse
                        );
                    }

                    // Return response
                    echo json_encode($response);

                } else {
                    echo "Error adding product: " . $conn->error;
                }
            }

            break;
        case "transaction":
            $conn->autocommit(FALSE);
            try {
                ////////////////////////////////////////////////////

                //////////////////dawod generate DeviceID per device used or login or whatevr and send it  also soruce, idk wtf source means ask ai team

                ////////////////////////////////////////////////////
                // Extract data from the POST request
                $userID = $_POST['UserID'];
                $deviceID = $_POST['DeviceID'];
                $deviceType = $_POST['DeviceType'];
                $browser = $_POST['Browser'];
                $ipAddress = $_POST['IPAddress'];
                $country = $_POST['Country'];
                $source = $_POST['Source'];
                $productIDs = $_POST['ProductIDs']; // Assuming the product IDs are provided as a comma-separated string like "3,4,16,21"

                // Generate a random OrderID
                $orderID = uniqid();


                // Calculate PurchaseValue and NumberOfItems
                $purchaseValue = 0;
                $numberOfItems = 0;
                $productIDsArray = explode(",", $productIDs); // Convert the comma-separated string to an array
                foreach ($productIDsArray as $productID) {
                    $sql = "SELECT Price FROM product WHERE ID = '$productID'";
                    $result = $conn->query($sql);
                    if ($result->num_rows > 0) {
                        $row = $result->fetch_assoc();
                        $price = intval($row["Price"]);
                        $purchaseValue += $price;
                        $numberOfItems++;
                    }
                }
                // Get the current timestamp for PurchaseTime
                $purchaseTime = date("m/d/Y H:i");

                $sql = "SELECT bbr.CreatedAt AS signup_time, u.sex, u.age
                FROM bot_behavior_record AS bbr
                INNER JOIN user AS u ON bbr.UserID = u.ID
                WHERE bbr.UserID = $userID";
                $response = $conn->query($sql)->fetch_assoc();
                // Extract and save values into variables
                $signup_time = $response['signup_time'];
                $sex = $response['sex'];
                $age = $response['age'];
                $age = intval($age);

                $transactionFraud = array(
                    'user_id' => $userID,
                    'signup_time' => $signup_time,
                    'purchase_time' => $purchaseTime,
                    'purchase_value' => $purchaseValue,
                    'device_id' => $deviceID,
                    'source' => $source,
                    'browser' => $browser,
                    'sex' => $sex,
                    'age' => $age,
                    'ip_address' => $ipAddress,
                    'IP_country' => $country
                );

                $responsetransactionFraud = sendPostRequest($transactionFraudEndpoint, json_encode($transactionFraud));

                // Handle responses
                $transactionFraudResponse = json_decode($responsetransactionFraud, true);
                //var_dump($transactionFraudResponse);
                $prediction = $transactionFraudResponse['prediction'];
                $class = ($prediction === "non-fraudulent") ? 0 : 1;

                if (isset($transactionFraudResponse['prediction'])) {
                    // Insert data into the 'device' table
                    $sql = "INSERT INTO device (Browser, DeviceID, DeviceType, Source) VALUES ('$browser', '$deviceID', '$deviceType', '$source')";
                    if ($conn->query($sql) === TRUE) {
                        $deviceID = $conn->insert_id; // Get the ID of the inserted device

                        // Insert data into the 'geolocation' table
                        $sql = "INSERT INTO geolocation (IPAddress, Country, device_ID) VALUES ('$ipAddress', '$country', '$deviceID')";
                        if ($conn->query($sql) === TRUE) {
                            $geolocationID = $conn->insert_id; // Get the ID of the inserted geolocation

                            // Insert data into the 'transactions' table
                            $sql = "INSERT INTO transactions (PurchaseTime, PurchaseValue, OrderID, NumberOfItems, UserID, DeviceID, geolocation_ID, class) 
                      VALUES ('$purchaseTime', '$purchaseValue', '$orderID', '$numberOfItems', '$userID', '$deviceID', '$geolocationID', '$class')";
                            if ($conn->query($sql) === TRUE) {
                                $transactionID = $conn->insert_id; // Get the ID of the inserted transaction

                                // Insert data into the 'product_transactions' table for each product
                                foreach ($productIDsArray as $productID) {
                                    // Check if the product transaction already exists
                                    $sql = "SELECT * FROM product_transactions WHERE transactions_ID = '$transactionID' AND product_ID = '$productID'";
                                    $result = $conn->query($sql);
                                    if ($result->num_rows === 0) {
                                        // If the product transaction does not exist, insert it
                                        $sql = "INSERT INTO product_transactions (transactions_ID, product_ID) VALUES ('$transactionID', '$productID')";
                                        if ($conn->query($sql) !== TRUE) {
                                            throw new Exception("Error adding product transaction: " . $conn->error);
                                        }
                                    }
                                }
                                // Commit the transaction if all queries are successful
                                $conn->commit();
                                // Return purchaseValue, orderID, and numberOfItems as JSON response
                                if ($prediction === "non-fraudulent") {
                                    // Continue with the code
                                    echo json_encode(array("numberOfItems" => $numberOfItems, "purchaseValue" => $purchaseValue, "orderID" => $orderID));
                                } else {
                                    // Handle fraudulent transaction
                                    echo json_encode(array("state" => "failure", "cause" => "fraudulent transaction"));
                                }
                            } else {
                                throw new Exception("Error adding transaction: " . $conn->error);
                            }
                        } else {
                            throw new Exception("Error adding geolocation: " . $conn->error);
                        }
                    } else {
                        throw new Exception("Error adding device: " . $conn->error);
                    }
                } else {
                    echo json_encode(array("state" => "failure", "cause" => "service down"));
                    throw new Exception("ai model is down");
                }
            } catch (Exception $e) {
                // Rollback the transaction if an error occurs
                $conn->rollback();
                echo json_encode(array("error" => "Transaction failed: " . $e->getMessage()));
            }
            break;
        ////////////////////////////admin apis///////////////////////////////////
        case "admin_get_users":
            //hi daowd
            // Check if userid parameter is set in the POST request
            if (isset($_POST['userid'])) {
                $userid = $_POST['userid'];
                // Check if the user exists and is an admin
                $sql = "SELECT isAdmin FROM user WHERE ID = $userid LIMIT 1";
                $result = $conn->query($sql);
                if ($result && $result->num_rows == 1) {
                    $row = $result->fetch_assoc();
                    $isAdmin = $row['isAdmin'];
                    if ($isAdmin == 1) {
                        // SQL query to retrieve user information from both tables
                        $sql = "SELECT u.ID, u.UserLanguage, u.Username, u.sex, u.age,
                                           bbr.CreatedAt, bbr.FollowersCount, bbr.FriendsCount, bbr.MembershipSubscription,
                                           bbr.AvgPurchasesPerDay, bbr.AccountAge, bbr.prod_fav_count
                                    FROM user u
                                    INNER JOIN bot_behavior_record bbr ON u.ID = bbr.UserID
                                    WHERE bbr.AccountType = 'Not Determined' AND u.isAdmin = 0
                                    LIMIT 100"; // Limiting to 100 users

                        // Execute the query
                        $result = $conn->query($sql);

                        // Check if query executed successfully
                        if ($result) {
                            // Fetch all rows into an associative array
                            $users = $result->fetch_all(MYSQLI_ASSOC);
                            // Prepare success response
                            $response = array(
                                "success" => true,
                                "users" => $users
                            );
                        } else {
                            // Query failed or no results found
                            $response = array(
                                "success" => false,
                                "message" => "No users found."
                            );
                        }
                    } else {
                        $response = array(
                            "success" => false,
                            "message" => "User is not an admin."
                        );
                    }
                } else {
                    $response = array(
                        "success" => false,
                        "message" => "User not found."
                    );
                }
            } else {
                $response = array(
                    "success" => false,
                    "message" => "Userid parameter is missing."
                );
            }
            echo json_encode($response);
            break;
        case "admin_user_autocomplete":
            // Extract the search term from the POST request
            $searchTerm = $_POST['searchTerm'];

            // Prepare SQL statement to retrieve unique user names matching the search term
            $sql = "SELECT DISTINCT u.ID, u.Username, bbr.AccountType FROM user u
                        LEFT JOIN bot_behavior_record bbr ON u.ID = bbr.UserID
                        WHERE u.Username LIKE '%$searchTerm%'
                        ORDER BY u.Username ASC LIMIT 50"; // Order by Username in ascending order

            $result = $conn->query($sql);

            // Check if there are any matching user names
            if ($result->num_rows > 0) {
                // Store the matching user names in an array
                $usernames = array();
                while ($row = $result->fetch_assoc()) {
                    // Extract username and account type
                    $username = $row["Username"];
                    $accountType = $row["AccountType"];

                    // Add username and account type to the array
                    $usernames[] = array(
                        "username" => $username,
                        "account_type" => $accountType
                    );
                }

                // Return the list of matching user names and their account types as JSON response
                echo json_encode(array('search' => $usernames));
            } else {
                // If no matching user names found, return empty array as JSON response
                echo json_encode(array());
            }
            break;
            case "admin_bot_detection":
                // hi daowd
                // Check if userids parameter is set in the POST request
    
                if (isset($_POST['userids'])) {
                    $useridsString = $_POST['userids'];
                    // Convert the userids string to an array
                    $userids = explode(",", $useridsString);
                    // Prepare SQL statement to retrieve user information
                    $useridsString = implode(",", $userids); // Re-implode for SQL query
                    $sql = "SELECT bbr.CreatedAt, bbr.HasDefaultProfile, bbr.HasDefaultProfileImage,
                    bbr.FollowersCount, bbr.FriendsCount, bbr.IsGeoEnabled, u.ID AS user_id,
                    u.UserLanguage AS user_lang, g.country AS user_location, u.Username,
                    pr.PurchaseCount, bbr.MembershipSubscription, bbr.AvgPurchasesPerDay,
                    bbr.AccountAge, bbr.prod_fav_count
             FROM bot_behavior_record bbr
             INNER JOIN user u ON bbr.UserID = u.ID
             LEFT JOIN (SELECT id, country FROM geolocation WHERE id IN ($useridsString)) g ON u.ID = g.id
             LEFT JOIN (SELECT UserID, COUNT(*) AS PurchaseCount FROM purchase_record GROUP BY UserID) pr ON u.ID = pr.UserID
             WHERE u.ID IN ($useridsString)
             ORDER BY bbr.CreatedAt DESC";
                    $result = $conn->query($sql);
                    // Check if there are any user information found
                    if ($result->num_rows > 0) {
                        // Initialize an array to store all user information
                        $userInformation = array();
    
                        // Fetch all rows in the result set
                        while ($row = $result->fetch_assoc()) {
                            // Extract each column into its separate variable for each row
                            $user = array(
                                "created_at" => $row['CreatedAt'],
                                "has_default_profile" => (bool) $row['HasDefaultProfile'],
                                "has_default_profile_img" => (bool) $row['HasDefaultProfileImage'],
                                "prod_fav_count" => intval($row['prod_fav_count']),
                                "followers_count" => intval($row['FollowersCount']),
                                "friends_count" => intval($row['FriendsCount']),
                                "is_geo_enabled" => (bool) $row['IsGeoEnabled'],
                                "user_id" => $row['user_id'],
                                "user_lang" => $row['user_lang'],
                                "user_location" => $row['user_location'],
                                "username" => $row['Username'],
                                "purchase_count" => intval($row['PurchaseCount']),
                                "membership / subscription" => $row['MembershipSubscription'] == 'premium' ? true : false,
                                "avg_purchases_per_day" => floatval($row['AvgPurchasesPerDay']),
                                "account_age" => intval($row['AccountAge'])
                            );
                            // Add the user information to the array
                            $userInformation[] = $user;
                        }
    
                        // Print or use $userInformation as needed
                        //print_r($userInformation);
                    }
                    $userData = json_encode($userInformation);
                    // Send POST request
                    $response = sendPostRequest($botDetectionEndpoint, $userData);
                    $botDetectionResponse = json_decode($response, true);
                    //var_dump($botDetectionResponse);
    
                    // Update AccountType based on bot detection response
                    foreach ($botDetectionResponse as $responseItem) {
                        $userId = $responseItem['user_id'];
                        $prediction = $responseItem['best_model_prediction'];
                        $accountType = ($prediction == 'human') ? 'Human' : 'Bot';
    
                        // Update the AccountType in the database
                        $updateSql = "UPDATE bot_behavior_record SET AccountType = '$accountType' WHERE UserID = $userId";
                        $conn->query($updateSql);
                    }
    
                    // Prepare response for which users got flagged as bots and which as humans
                    $flaggedUsers = array();
                    foreach ($botDetectionResponse as $responseItem) {
                        $userId = $responseItem['user_id'];
                        $prediction = $responseItem['best_model_prediction'];
    
                        // Get the username from the user information array
                        $username = '';
                        foreach ($userInformation as $user) {
                            if ($user['user_id'] == $userId) {
                                $username = $user['username'];
                                break;
                            }
                        }
    
                        // Add the user ID, username, and prediction to flagged users
                        $flaggedUsers[] = array(
                            'userid' => $userId,
                            'username' => $username,
                            'prediction' => $prediction
                        );
                    }
    
                    // Return the flagged users
                    echo json_encode($flaggedUsers);
    
                } else {
                    echo json_encode(array("error" => "Userids parameter is missing."));
                }
                break;
    
        case "admin_powerBI":
            //hi dawod
            // Define the directory where the images are stored
            $imageDirectory = dirname(__FILE__) . '/images/';

            // Check if the directory exists
            if (is_dir($imageDirectory)) {
                // Get the list of files in the directory
                $images = scandir($imageDirectory);

                // Remove '.' and '..' from the list of files
                $images = array_diff($images, array('..', '.'));

                // Create an array to store image links
                $imageLinks = array();

                // Generate links to the images
                foreach ($images as $image) {
                    // Construct the URL for each image
                    $imageLinks[] = 'http://' . $_SERVER['HTTP_HOST'] . '/abok/images/' . urlencode($image);
                }

                // Return the list of image links as JSON response
                echo json_encode(array('image_links' => $imageLinks));
            } else {
                // If the directory does not exist, return an error message
                echo json_encode(array('error' => 'Images directory does not exist.'));
            }
            break;
        

        //hani was here
        default:
            // If the action is not specified or invalid, return error message
            echo json_encode(array("error" => "Invalid action"));
            break;
    }
}
// Close the database connection
$conn->close();
?>