#!/bin/bash
echo "Requesting the Malicious URL model"
echo "-----------------------------------------------"
curl -X POST http://localhost:5000/externalUrl -H "Content-Type: application/json" -d '{"url": "http://www.824555.com/app/member/SportOption.php?uid=guest&langx=gb"}'
echo "-----------------------------------------------"

echo "Requesting the Content Moderation Model"
echo "-----------------------------------------------"
curl -X POST http://localhost:5000/contentModeration -H "Content-Type: application/json" -d "{\"data\": [{\"url\": \"https://www.amazon.co.uk/dp/B084HXVWKZ\", \"title\": \"Mizuno Men's Wave Duel Running Shoe\", \"asin\": \"B084HXVWKZ\", \"brand\": \"Visit the Mizuno Store\", \"breadcrumbs\": \"Shoes/Men's Shoes/Fashion & Athletic Trainers/Sports & Outdoor Shoes/Running Shoes/Road Running Shoes\", \"features\": \"[{\\\"Outer Material\\\": \\\"Synthetic\\\"}, {\\\"Inner Material\\\": \\\"Manmade\\\"}, {\\\"Sole\\\": \\\"Synthetic\\\"}, {\\\"Closure\\\": \\\"Lace-Up\\\"}, {\\\"Shoe Width\\\": \\\"Medium\\\"}]\", \"location\": \"US, FL, Jacksonville\", \"has_company_logo\": 1, \"has_questions\": 0, \"industry\": \"Real Estate\"}]}"
echo "-----------------------------------------------"

echo "Requesting the Transaction Model"
echo "-----------------------------------------------"
curl -X POST http://localhost:5000/transaction \
-H "Content-Type: application/json" \
-d '{"user_id": 22058, "signup_time": "2/24/2015 22:55", "purchase_time": "4/18/2015 2:47", "purchase_value": 34, "device_id": "QVPSPJUOCKZAR", "source": "SEO", "browser": "Chrome", "sex": "M", "age": 39, "ip_address": 732758368.8, "IP_country": "Japan"}'
echo "-----------------------------------------------"


echo "Requesting the Bot Model"
echo "-----------------------------------------------"
curl -X POST http://localhost:5000/detect_bots \
-H "Content-Type: application/json" \
-d '{"created_at": "10/15/2016 21:32", "has_default_profile": false, "has_default_profile_img": false, "prod_fav_count": 4, "followers_count": 1589, "friends_count": 4, "is_geo_enabled": false, "user_id": "787406546624053248", "user_lang": "en", "user_location": "unknown", "username": "best_in_dumbest", "purchase_count": 11041, "membership_subscription": false, "avg_purchases_per_day": 7.87, "account_age": 1403}'
echo "-----------------------------------------------"



echo "Requesting the Bot Model ***BATCH***"
echo "-----------------------------------------------"
curl -X POST http://localhost:5000/detect_bots_batch \
-H "Content-Type: application/json" \
-d '[{"created_at": "10/15/2016 21:32", "has_default_profile": false, "has_default_profile_img": false, "prod_fav_count": 4, "followers_count": 1589, "friends_count": 4, "is_geo_enabled": false, "user_id": "787406546624053248", "user_lang": "en", "user_location": "unknown", "username": "best_in_dumbest", "purchase_count": 11041, "membership_subscription": false, "avg_purchases_per_day": 7.87, "account_age": 1403}, {"created_at": "10/15/2016 21:32", "has_default_profile": false, "has_default_profile_img": false, "prod_fav_count": 4, "followers_count": 1589, "friends_count": 4, "is_geo_enabled": false, "user_id": "787406546624053248", "user_lang": "en", "user_location": "unknown", "username": "best_in_dumbest", "purchase_count": 11041, "membership_subscription": false, "avg_purchases_per_day": 7.87, "account_age": 1403}]'
echo "-----------------------------------------------"