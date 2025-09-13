# model_loader.py
import tensorflow as tf
import numpy as np
from PIL import Image

class ModelLoader:
    def __init__(self, model_path, labels_path):
        # ✅ load h5 model directly
        self.model = tf.keras.models.load_model(model_path, compile=False)

        with open(labels_path, 'r') as f:
            self.labels = [line.strip() for line in f.readlines()]

    def predict(self, image_path):
        img = Image.open(image_path).convert('RGB').resize((224, 224))
        img_array = np.expand_dims(np.array(img)/255.0, axis=0)
        predictions = self.model.predict(img_array)
        class_idx = np.argmax(predictions[0])
        return self.labels[class_idx]
