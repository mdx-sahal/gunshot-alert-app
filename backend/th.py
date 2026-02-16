import numpy as np
import tensorflow as tf
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score
import seaborn as sns
import matplotlib.pyplot as plt

# Function to load .npy files instead of .csv
def load_stacked_feature_arrays(split='train'):
    path = "C:/Users/ASUS/Desktop/python"  # Adjust to your directory
    print(f'Loading {split} set...', end=' ')
    X = np.load(f"{path}/X_{split}.npy")
    y = np.load(f"{path}/y_{split}.npy")
    print('done!')
    return X, y

# Load the training, validation, and test sets
X_train, y_train = load_stacked_feature_arrays('train')
X_val, y_val = load_stacked_feature_arrays('val')
X_test, y_test = load_stacked_feature_arrays('test')

# Define evaluation functions
def _sensitivity(y_actual, y_pred):
    cm = confusion_matrix(y_actual, y_pred)
    FN = cm[1, 0]
    TP = cm[1, 1]
    sensitivity = (TP / (TP + FN)).round(2) if TP + FN != 0 else 0.0
    return sensitivity

def _specificity(y_actual, y_pred):
    cm = confusion_matrix(y_actual, y_pred)
    TN = cm[0, 0]
    FP = cm[0, 1]
    specificity = (TN / (TN + FP)).round(2) if TN + FP != 0 else 0.0
    return specificity

def report(y_actual, y_pred):
    print(classification_report(y_actual, y_pred))
    print('Sensitivity:', _sensitivity(y_actual, y_pred))
    print('Specificity:', _specificity(y_actual, y_pred))
    cm_matrix = confusion_matrix(y_actual, y_pred)
    sns.heatmap(cm_matrix, annot=True, fmt='d')
    plt.show()

# Define 1D CNN architecture
input_shape = (X_train.shape[1], 1)  # Reshape input for 1D CNN
num_classes = 10

model_1D = tf.keras.Sequential([
    tf.keras.layers.Conv1D(32, 3, activation='relu', input_shape=input_shape),
    tf.keras.layers.Conv1D(32, 3, activation='relu'),
    tf.keras.layers.Dropout(0.5),
    tf.keras.layers.MaxPooling1D(),
    tf.keras.layers.Flatten(),
    tf.keras.layers.Dense(64, activation='relu'),
    tf.keras.layers.Dense(num_classes, activation='softmax')
])

# Compile the model
model_1D.compile(
    optimizer='adam',
    loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=False),
    metrics=['accuracy']
)

# Reshape the data to include a channel dimension (required for 1D CNN)
X_train = X_train[..., np.newaxis]
X_val = X_val[..., np.newaxis]
X_test = X_test[..., np.newaxis]

# Train the model
history = model_1D.fit(
    X_train, y_train,
    validation_data=(X_val, y_val),
    epochs=20,
    batch_size=1
)
np.save("training_history.npy", history.history)
# Evaluate on test set
y_pred = model_1D.predict(X_test)
y_pred = np.argmax(y_pred, axis=1)

# General accuracy
print('Model test accuracy: {}%'.format(round(accuracy_score(y_test, y_pred) * 100, 2)))

# Binary evaluation for gunshot class (assuming label_map is defined elsewhere)
interest_class = 1  # Example: Replace with the correct index for 'gun_shot'
y_gun_shot_pred = [1 if x == interest_class else 0 for x in y_pred]
y_gun_shot_test = [1 if x == interest_class else 0 for x in y_test]

# Print evaluation report for gunshot class
report(y_gun_shot_test, y_gun_shot_pred)

# Save the model
model_1D.save('model_02.h5')