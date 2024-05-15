import pandas as pd
import calendar




def preprocess_transaction(data , columns):
    #import training columns model
    train_columns = columns
    # Convert datetime columns to datetime objects
    data["purchase_time"] = pd.to_datetime(data["purchase_time"])
    data["signup_time"] = pd.to_datetime(data["signup_time"])
    
    # Extract features from datetime columns
    data["month_purchase"] = data.purchase_time.apply(
        lambda x: calendar.month_name[x.month])
    data["weekday_purchase"] = data.purchase_time.apply(
        lambda x: calendar.day_name[x.weekday()])
    data["hour_of_the_day"] = data.purchase_time.apply(lambda x: x.hour)
    data["period_of_the_day"] = data.hour_of_the_day.apply(lambda x:
                                                           "late night" if x < 4 else
                                                           "early morning" if x < 8 else
                                                           "morning" if x < 12 else
                                                           "early arvo" if x < 16 else
                                                           "arvo" if x < 20 else
                                                           "evening"
                                                           )
    data["age_category"] = data.age.apply(lambda x:
                                          "< 40" if x < 40 else
                                          "40 - 49" if x < 50 else
                                          "50 -59" if x < 60 else
                                          "60 - 69" if x < 70 else
                                          " > 70")
    data["seconds_since_signup"] = (
        data.purchase_time - data.signup_time).apply(lambda x: x.total_seconds())
    data["quick_purchase"] = data.seconds_since_signup.apply(
        lambda x: 1 if x < 30 else 0)

    # Drop unnecessary columns
    columns_to_remove = ["user_id", "signup_time", "purchase_time", "device_id",
                         "ip_address", "hour_of_the_day", "seconds_since_signup", "age"]
    data.drop(columns_to_remove, axis=1, inplace=True)

    
    # One-hot encoding
    features = pd.get_dummies(data, drop_first=True)

    # Ensure the new data has the same columns as the training data
    features = features.reindex(columns=train_columns, fill_value=0)

    return features
