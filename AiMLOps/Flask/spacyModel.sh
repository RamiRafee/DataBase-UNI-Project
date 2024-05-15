#!/bin/bash

# Check if spaCy is installed
if ! command -v spacy &> /dev/null
then
    echo "spaCy is not installed. Installing..."
    python -m pip install spacy
fi

# Download the 'en_core_web_sm' model
echo "Downloading 'en_core_web_sm' model..."
python -m spacy download en_core_web_sm

echo "Done!"
