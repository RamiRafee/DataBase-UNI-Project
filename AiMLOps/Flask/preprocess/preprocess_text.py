import string
import spacy
import ast
from spacy.lang.en.stop_words import STOP_WORDS

nlp = spacy.load("en_core_web_sm")
punctuations = string.punctuation
stop_words = spacy.lang.en.stop_words.STOP_WORDS

def clean_text(text):
    return text.strip().lower()

def spacy_tokenizer(sentence):
    doc = nlp(sentence)
    mytokens = [token.lemma_.lower().strip() if token.lemma_ != "-PRON-" else token.lower_ for token in doc]
    mytokens = [token for token in mytokens if token not in stop_words and token not in punctuations]
    return mytokens

def preprocess_features_string(features_str):
    # Replace single quotes with double quotes
    features_str = features_str.replace("'", '"')
    return features_str

def extract_shoe_materials(features_str):
    # Preprocess the features string
    features_str = preprocess_features_string(features_str)

    try:
        # Parse the features string to a Python list of dictionaries
        features_list = ast.literal_eval(features_str)
    except (SyntaxError, ValueError):
        # Return an empty list if parsing fails
        return ''

    # List to store extracted materials
    materials = []

    # Iterate over each feature dictionary
    for feature in features_list:
        # Extract the value corresponding to 'Outer Material', 'Inner Material', 'Sole', and 'Closure' keys
        if 'Outer Material' in feature:
            materials.append(feature['Outer Material'])
        if 'Inner Material' in feature:
            materials.append(feature['Inner Material'])
        if 'Sole' in feature:
            materials.append(feature['Sole'])
        if 'Closure' in feature:
            materials.append(feature['Closure'])

    # Join the extracted materials with commas
    return ','.join(materials)