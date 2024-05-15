import os
import pickle
from preprocess.preprcoess_url import preprocess_url


def load_malicious_url_model():
    # Get the directory of the current script
    current_dir = os.path.dirname(os.path.abspath(__file__))
    # Construct the path to the model file inside the static folder
    model_path = os.path.join(current_dir, 'static', 'mul_url_xgb.pkl')
    with open(model_path, 'rb') as f:
        model = pickle.load(f)
    return model

def predict_url_type(url,model):

    processed_url = preprocess_url(url)
    prediction = model.predict(processed_url)[0]

    labels = ['benign', 'defacement', 'malware', 'phishing']
    predicted_type = labels[prediction]

    return predicted_type