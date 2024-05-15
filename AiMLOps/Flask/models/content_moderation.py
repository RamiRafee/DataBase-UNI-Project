# random forest gives good results

import pickle
import ast
import re
import os
import string
import numpy as np
import pandas as pd
from sklearn.metrics import accuracy_score
import random
import missingno
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.base import TransformerMixin
from wordcloud import WordCloud
import spacy

from spacy.lang.en.stop_words import STOP_WORDS
from spacy.lang.en import English
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from xgboost import XGBClassifier
from sklearn.svm import SVC
from sklearn.feature_extraction.text import CountVectorizer

from preprocess.preprocess_text import clean_text, extract_shoe_materials


class predictors:
    def transform(self, X, **transform_params):
        return [clean_text(text) for text in X]

    def fit(self, X, y=None, **fit_params):
        return self

    def get_params(self, deep=True):
        return {}

nlp = spacy.load("en_core_web_sm")
punctuations = string.punctuation
stop_words = spacy.lang.en.stop_words.STOP_WORDS
def spacy_tokenizer(sentence):
    doc = nlp(sentence)
    mytokens = [token.lemma_.lower().strip() if token.lemma_ != "-PRON-" else token.lower_ for token in doc]
    mytokens = [token for token in mytokens if token not in stop_words and token not in punctuations]
    return mytokens

# Load the content moderation models
def load_content_moderation_models():
    models = {}
    model_files = [
        "RandomForestClassifier_content_moderation.pkl",
        "LogisticRegression_content_moderation.pkl",
        "SVC_content_moderation.pkl",
        "XGBClassifier_content_moderation.pkl"
    ]
    # Get the directory of the current script
    current_dir = os.path.dirname(os.path.abspath(__file__))
    # Construct the path to the model file inside the static folder
    for file in model_files:
        model_path = os.path.join(current_dir, 'static', file)
        print(file)
        with open(model_path, 'rb') as f:
            model_name = file.split("_")[0]
            models[model_name] = pickle.load(f)
    return models

def predict_fraudulent(data, models):
    label_map = {0: 'not fraudulent', 1: 'fraudulent'}
    forest_model = models.get('RandomForestClassifier')
    if forest_model is None:
        return {}

    # Preprocess the input data
    data['text'] = data['title'] + ' ' + data['location'] + ' ' + data['brand'] + \
        ' ' + data['breadcrumbs'] + ' ' + \
        data['features'] + ' ' + data['industry']
    data.fillna('', inplace=True)

    # Feature engineering: Extract features from the text
    data['cleaned_features'] = data['features'].apply(
        extract_shoe_materials)

    # Combine features with text
    data['text'] = data['text'] + ' ' + data['cleaned_features']

    # Make prediction using the RandomForest model
    predicted = forest_model.predict(data['text'])
    confidence = None

    if hasattr(forest_model, "predict_proba"):
        confidence = forest_model.predict_proba(data['text']).max(axis=1)[0]
    # For models that don't have predict_proba, you can use other methods to estimate confidence

    if confidence is not None:
        return {
            "best_model": "RandomForestClassifier",
            "best_model_prediction": label_map[predicted[0]],
            "confidence": confidence
        }
    return {}


if __name__ == "__main__":
    # Load the trained models
    models = load_content_moderation_models()

    # Sample data
    data1 = pd.DataFrame({
        'url': ['https://www.amazon.co.uk/dp/B08N587YZ9'],
        'title': ["Fila Women's Oakmont Tr Sneaker"],
        'asin': ['B08N587YZ9'],
        'price': ['£49.57 - £234.95'],
        'brand': ['Fila'],
        'product_details': ["Product Dimensions:32.51 x 21.84 x 12.19 cm; 952.54 GramsDate First Available‏:‎6 Jun. 2020Manufacturer‏:‎FilaASIN‏:‎B089RQLYNWItem model number‏:‎5JM00948-990Department‏:‎Women's"],
        'breadcrumbs': ['Shoes/Women\'s Shoes/Fashion & Athletic Trainers/Fashion Trainers'],
        'features': ['[{"Outer Material": "fabric"}, {"Sole": "Rubber"}, {"Closure": "Lace-Up"}, {"Heel Type": "No Heel"}, {"Shoe Width": "medium"}]'],
        'location': ['NZ, , Auckland'],
        'has_company_logo': [1],
        'has_questions': [0],
        'industry': ['Marketing and Advertising'],
        'fraudulent': [0]
    })

    data2 = pd.DataFrame({
        'url': ['https://www.amazon.co.uk/dp/B07NSPN1G2'],
        'title': ["Skechers Men's Go Run 600 - Zexor School Uniform Shoe"],
        'asin': ['B07NSPN1G2'],
        'price': ['£31.21 - £157.64'],
        'brand': ['Visit the Skechers Store'],
        'product_details': ["Package Dimensions: 21.08 x 14.73 x 8.13 cm; 153.09 GramsDate First Available‏:‎9 Jan. 2020Manufacturer‏:‎Skechers KidsASIN‏:‎B07NSPL4X9Item model number‏:‎97869LDepartment‏:‎Boy's"],
        'breadcrumbs': [''],
        'features': ['[{"Sole": "Synthetic"}, {"Closure": "Lace-Up"}, {"Shoe Width": "Medium"}]'],
        'location': ['US, TX, Deweyville'],
        'has_company_logo': [1],
        'has_questions': [0],
        'industry': [''],
        'fraudulent': [1]
    })

    data3 = pd.DataFrame({
        'url': ['https://www.amazon.co.uk/dp/B084HXVWKZ'],
        'title': ["Mizuno Men's Wave Duel Running Shoe"],
        'asin': ['B084HXVWKZ'],
        'price': ['£79.95 - £143.26'],
        'brand': ['Visit the Mizuno Store'],
        'product_details': ["Product Dimensions:30 x 20 x 5 cm; 800 GramsDate First Available‏:‎11 Feb. 2020Manufacturer‏:‎MizunoASIN‏:‎B084HXZ364Item model number‏:‎U1GD1960Department‏:‎Men's"],
        'breadcrumbs': ['Shoes/Men\'s Shoes/Fashion & Athletic Trainers/Sports & Outdoor Shoes/Running Shoes/Road Running Shoes'],
        'features': ['[{"Outer Material": "Synthetic"}, {"Inner Material": "Manmade"}, {"Sole": "Synthetic"}, {"Closure": "Lace-Up"}, {"Shoe Width": "Medium"}]'],
        'location': ['US, FL, Jacksonville'],
        'has_company_logo': [1],
        'has_questions': [0],
        'industry': ['Real Estate'],
        'fraudulent': [1]
    })
    # Make prediction
    predictions = predict_fraudulent(data3, models)

    for name, prediction in predictions.items():
        if prediction[0] == 1:
            print(f"Prediction using {name}: Fraudulent ({prediction[0]})")
        else:
            print(f"Prediction using {name}: Non-fraudulent ({prediction[0]})")