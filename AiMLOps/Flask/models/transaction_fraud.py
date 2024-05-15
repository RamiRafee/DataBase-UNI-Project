import os
import pickle
import calendar
from preprocess.preprocess_transaction import preprocess_transaction



def load_transaction_model():
    # Get the directory of the current script
    current_dir = os.path.dirname(os.path.abspath(__file__))
    # Construct the path to the model file inside the static folder
    
    logistic_regression_path = os.path.join(current_dir, 'static', 'fraudE_log_reg_transactions.pkl')
    with open(logistic_regression_path, 'rb') as f:
        logistic_regression = pickle.load(f)

    
    return logistic_regression 

def load_train_columns_model():
    # Get the directory of the current script
    current_dir = os.path.dirname(os.path.abspath(__file__))
    # Construct the path to the model file inside the static folder
    train_columns_path = os.path.join(current_dir, 'static', 'train_columns_transactions.pkl')
    with open(train_columns_path, 'rb') as f:
        train_columns = pickle.load(f)
    return train_columns

# Function to make predictions
def predict(data,columns,lg_model):
    preprocessed_data = preprocess_transaction(data, columns)
    predictions = lg_model.predict(preprocessed_data)
    return predictions