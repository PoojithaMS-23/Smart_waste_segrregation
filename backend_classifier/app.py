from flask import Flask, request, jsonify
from flask_cors import CORS    # add this
from model_loader import ModelLoader
import os

app = Flask(__name__)
model_loader = ModelLoader("keras_model.h5", "labels.txt")
CORS(app)                      

UPLOAD_FOLDER = "uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@app.route("/predict", methods=["POST"])
def predict():
    if "file" not in request.files:
        return jsonify({"error": "No file uploaded"}), 400
    file = request.files["file"]
    file_path = os.path.join(UPLOAD_FOLDER, file.filename)
    file.save(file_path)

    label = model_loader.predict(file_path)
    return jsonify({"prediction": label})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

