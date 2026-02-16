# Gunshot Detection and Alert System 🔫🚨

A machine learning-based system designed to detect gunshot sounds and alert users via a responsive Flutter web interface. The system processes audio inputs and presents alerts with timestamp and location metadata. The web app currently uses simulated alerts to demonstrate the UI.

## 💡 Overview

This project uses a 1D Convolutional Neural Network (CNN) trained on extracted audio features to identify gunshot sounds. The frontend is built using Flutter Web and displays real-time alerts, alert history, and detailed views.

## 📱 Features

- 🔊 Gunshot detection using a trained 1D CNN model
- 🖥️ Flutter web interface for alert visualization
- 🧠 Simulated alert generation for UI testing
- 📄 Alert Details page with timestamp and metadata
- 🕒 Alert History page for reviewing past events
- 🧭 Icon-based navigation between pages

## 🛠️ Tech Stack

| Component      | Technology                            |
|----------------|----------------------------------------|
| Frontend       | Flutter Web                            |
| ML Frameworks  | TensorFlow, Scikit-learn, NumPy        |
| Audio Processing | Librosa                              |
| Dataset        | ESC-50 + Custom Gunshot Audio Samples  |

## 🧠 Machine Learning Model

- Architecture: **1D Convolutional Neural Network**
- Accuracy: ~80% overall, **99% for gunshot class**
- Features extracted using `librosa`:
  - Mel-spectrogram
  - MFCCs
  - Spectral Contrast
  - Chromagram
  - Tonnetz
- Features were flattened and stacked into 1D arrays for CNN input
- Evaluation includes classification metrics, confusion matrix, sensitivity & specificity

## 🌐 Web Application

- Built with **Flutter Web**
- Pages Implemented:
  - **Login Page** with mock credentials
  - **Home Page** with real-time alert feed
  - **Alert History Page**
  - **Alert Details Page**
- Navigation through custom icons
- Includes custom favicon and styling tweaks

## 🧪 Testing Setup

Currently uses mock alert data to simulate map locations.Uploads .wav audio files to detect whether it is gunshot or not.

## 🙏 Acknowledgements

This project was inspired by the structure and ideas presented in the open-source repository [Gunshot Detection System](https://github.com/mariamkhmahran/gunshot-detection-system) by Mariam Khmahran. While the model architecture and dataset handling have been significantly modified and adapted for our custom use case, her work served as an initial reference.

## 👥 Team Members

- **Muhammad Sahal** (VJC22CS098)  
- **Don Vincent** (VJC22CS056)  
- **Edwin Dileep** (VJC22CS059)  
- **Basil Jeby** (VJC22CS043)  
- **Guide:** Dr. Neenu Daniel (Associate Professor, CSE)

## 🚀 Getting Started

```bash
flutter pub get
flutter run -d chrome
