
import pandas as pd
from flask import Flask, request, jsonify
from models.malicious_url_detection import predict_url_type, load_malicious_url_model
from models.content_moderation import predictors, predict_fraudulent, load_content_moderation_models , spacy_tokenizer
from models.transaction_fraud import predict,load_train_columns_model,load_transaction_model
from models.detect_bots import predict_bot
app = Flask(__name__)




@app.route('/externalUrl', methods=['POST'])
def predict_externalUrl():
    url = request.json.get('url')
    if not url:
        return jsonify({'error': 'URL not provided'}), 400
    model = load_malicious_url_model()
    predicted_type = predict_url_type(url,model)
    return jsonify({'predicted_type': predicted_type})

@app.route('/contentModeration', methods=['POST'])
def predict_content():
    data = request.json.get('data')
    if not data:
        return jsonify({'error': 'Data not provided'}), 400
    # #Construct DataFrame from JSON data
    # df = pd.DataFrame(data)
    # # Make prediction
    # predictions = predict_fraudulent(df, load_content_moderation_models())
    # result = {
    #     'predictions': predictions
    # }
    # return jsonify(result)

    try:
        # Construct DataFrame from JSON data
        df = pd.DataFrame(data)
        # Make prediction
        predictions = predict_fraudulent(df, load_content_moderation_models())
        result = {
            'predictions': predictions
        }
        return jsonify(result)
    except Exception as e:
        return jsonify({'error': str(e)}), 500



@app.route('/transaction', methods=['POST'])
def submit_transaction():
    # Get the transaction data from the POST request
    transaction_data = request.json
    # Convert the dictionary to a DataFrame
    transaction_df = pd.DataFrame([transaction_data])
    columns = load_train_columns_model()
    model = load_transaction_model()
    # Make predictions
    prediction = predict(transaction_df,columns,model)
    
    # Map prediction values to labels
    prediction_label = "fraudulent" if prediction[0] == 1 else "non-fraudulent"
    
    return jsonify({"prediction": prediction_label})



@app.route('/detect_bots', methods=['POST'])
def detect_bots():
    # Get the data from the POST request
    data = request.json

    # Convert the data into a DataFrame
    row = pd.DataFrame([data])


    # Make predictions
    predictions = predict_bot( row)

    return jsonify(predictions)



@app.route('/detect_bots_batch', methods=['POST'])
def detect_bots_batch():
    # Get the data from the POST request
    data = request.json

    # Convert the data into a DataFrame
    batch_df = pd.DataFrame(data)


    # Make predictions for each row in the batch
    predictions = {}
    for index, row in batch_df.iterrows():
        prediction = predict_bot( pd.DataFrame([row]))
        predictions[index] = prediction

    return jsonify(predictions)

if __name__ == '__main__':
    app.run(debug=True)
