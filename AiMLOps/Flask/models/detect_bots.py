import os
import pandas as pd
import pickle
from preprocess.preprocess_bot import preprocess_data




def load_models(model_names):
    models = {}
    # Get the directory of the current script
    current_dir = os.path.dirname(os.path.abspath(__file__))
    for name in model_names:
        file = f'bots_detection_{name}_model.pkl'
        model_path = os.path.join(current_dir, 'static', file)
        with open(model_path, 'rb') as model_file:
            models[name] = pickle.load(model_file)
    return models

def predict_bot( data):
    # Load the trained models
    model_names = ['knn', 'lr', 'tree', 'forest', 'xgb']
    models = load_models(model_names)

    label_map = {0: 'human', 1: 'bot'}
    user_id = data['user_id'].values[0]
    row = preprocess_data(data)
    max_confidence = 0
    best_model = None

    for name, model in models.items():
        confidences = model.predict_proba(row).max(axis=1)
        confidence = confidences[0]

        if confidence > max_confidence:
            max_confidence = confidence
            best_model = name

    if best_model is not None:
        prediction = model.predict(row)
        prediction_label = label_map[prediction[0]]
        return {
            "user_id": user_id,
            "best_model":best_model,
            "best_model_prediction": prediction_label,
            "confidence": max_confidence
            }
    return {}


if __name__ == "__main__":

    # Load the dataset
    raw_df = pd.read_csv("../../../data/ecommerce_human_bot.csv")
    raw_df = raw_df.iloc[[0]]

    # Preprocess the data
    processed_df = preprocess_data(raw_df)

    # Make predictions using each model
    predictions = predict_bot( processed_df)

    # Print predictions
    for name, prediction in predictions.items():
        print(f"Model: {name}")
        print("Prediction:", prediction)
        print()

    print("Prediction Done Successfully...")