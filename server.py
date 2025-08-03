from flask import Flask, request, jsonify
import numpy as np
import tensorflow as tf
import os
import feature3  # Your feature extraction module

app = Flask(__name__)

# Load trained model
MODEL_PATH = "model_02.h5"
model = tf.keras.models.load_model(MODEL_PATH)

# Allowed file types
ALLOWED_EXTENSIONS = {'wav'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({"error": "No file provided"}), 400

    file = request.files['file']

    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    if file and allowed_file(file.filename):
        # Save uploaded file temporarily
        file_path = os.path.join("uploads", file.filename)
        file.save(file_path)

        # Extract features using feature3 module
        try:
            features = feature3.extract_features(file_path)  
            if features is None:
                return jsonify({"error": "Feature extraction failed"}), 500

            features = np.array(features).reshape(1, -1)  # Ensure correct shape for model
            
            # Predict using ML model
            prediction = model.predict(features)
            result = "Gunshot Detected" if prediction[0][0] > 0.5 else "No Gunshot"

            # Cleanup: Remove temporary file after processing
            os.remove(file_path)

            return jsonify({"prediction": result, "confidence": float(prediction[0][0])})

        except Exception as e:
            return jsonify({"error": str(e)}), 500

    return jsonify({"error": "Invalid file type"}), 400

if __name__ == '__main__':
    os.makedirs("uploads", exist_ok=True)  # Ensure uploads folder exists
    app.run(host="0.0.0.0", port=5000, debug=True)
