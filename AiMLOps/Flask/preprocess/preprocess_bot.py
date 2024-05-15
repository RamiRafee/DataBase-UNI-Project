import pandas as pd

def preprocess_data(raw_df):
    # Extract features from 'created_at'
    raw_df['created_at'] = pd.to_datetime(raw_df['created_at'])
    raw_df['created_year'] = raw_df['created_at'].dt.year
    raw_df['created_month'] = raw_df['created_at'].dt.month
    raw_df['created_day'] = raw_df['created_at'].dt.day
    raw_df['created_hour'] = raw_df['created_at'].dt.hour

    # Drop individual categorical columns and other non-numeric columns
    raw_df.drop(columns=['user_id', 'user_lang', 'user_location',
                          'username', 'created_at'], inplace=True)
    return raw_df