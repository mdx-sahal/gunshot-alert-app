import librosa
import numpy as np

def extract_features(file_path):
    try:
        # Load audio
        y, sr = librosa.load(file_path, sr=None)
        if len(y) < 512:  
            raise ValueError(f"File {file_path} is too short for feature extraction.")

        # Padding for FFT stability
        padded_length = 2 ** int(np.ceil(np.log2(len(y))))
        y = np.pad(y, (0, max(0, padded_length - len(y))), mode='constant')

        # Dynamic n_fft calculation
        min_frame_size = max(512, len(y) // 70)
        n_fft_size = min(len(y), max(512, 2 ** int(np.floor(np.log2(min(min_frame_size, 1024))))))

        # Harmonic-Percussive Separation
        if len(y) > 2048:  
            y_harmonic, _ = librosa.effects.hpss(y)
        else:
            y_harmonic = y

        # Extract Features
        mel_spec = librosa.feature.melspectrogram(y=y_harmonic, sr=sr, n_fft=n_fft_size, hop_length=n_fft_size // 4)
        mfccs = librosa.feature.mfcc(y=y_harmonic, sr=sr, n_mfcc=13, n_fft=n_fft_size, hop_length=n_fft_size // 4)
        spectral_contrast = librosa.feature.spectral_contrast(y=y_harmonic, sr=sr, n_fft=n_fft_size, hop_length=n_fft_size // 4)
        chroma = librosa.feature.chroma_stft(y=y_harmonic, sr=sr, n_fft=n_fft_size, hop_length=n_fft_size // 4)
        tonnetz = librosa.feature.tonnetz(y=librosa.effects.harmonic(y), sr=sr)

        # Convert 2D features into 1D
        feature_vector = np.hstack([
            np.mean(spectral_contrast, axis=1),
            np.mean(tonnetz, axis=1),
            np.mean(chroma, axis=1),
            np.mean(mel_spec, axis=1),
            np.mean(mfccs, axis=1)
        ])

        return feature_vector.tolist()  # Convert to list for JSON serialization

    except Exception as e:
        return {"error": str(e)}
