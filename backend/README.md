# Skin Disease Prediction Backend (AI-Powered)

This is the Flask backend API for the Skin Disease Prediction mobile application with real AI-powered skin disease classification.

## Features

- **AI-Powered Prediction**: Real convolutional neural network for skin disease classification
- User registration and authentication
- Image upload and preprocessing
- 7-class skin disease classification (HAM10000 dataset classes)
- Treatment solution recommendations
- CORS enabled for mobile app integration
- Comprehensive logging and error handling

## AI Model

The backend uses a custom CNN model trained to classify 7 types of skin diseases:
- Actinic keratosis
- Basal cell carcinoma
- Benign keratosis-like lesions
- Dermatofibroma
- Melanoma
- Melanocytic nevi
- Vascular lesions

## Setup

1. Install Python 3.8 or higher
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Run the application:
   ```bash
   python app.py
   ```

The API will be available at `http://localhost:5000`

## API Endpoints

### Authentication
- `POST /signup` - User registration
- `POST /signin` - User login

### Prediction
- `POST /predict` - Upload image for skin disease prediction
- `POST /solution` - Get treatment solution for a disease

### Health Check
- `GET /health` - API health status

## Request/Response Examples

### Sign Up
```json
POST /signup
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123"
}
```

### Sign In
```json
POST /signin
{
  "email": "john@example.com",
  "password": "password123"
}
```

### Predict Disease
```
POST /predict
Content-Type: multipart/form-data
image: [image file]
```

Response:
```json
{
  "diseaseName": "Eczema",
  "description": "A skin condition causing itchy, red, and dry patches.",
  "confidence": 0.92
}
```

### Get Solution
```json
POST /solution
{
  "diseaseName": "Eczema"
}
```

Response:
```json
{
  "diseaseName": "Eczema",
  "solution": "Treatment includes moisturizing regularly..."
}
```

## AI Model Details

### Model Architecture
- **Input**: 224x224x3 RGB images
- **Architecture**: Custom CNN with 4 convolutional blocks
- **Features**: Batch normalization, dropout, global average pooling
- **Output**: 7-class softmax classification

### First Run
On first startup, the model will:
1. Create a new CNN model
2. Train with dummy data (for demonstration)
3. Save the model to `models/skin_disease_model.h5`
4. Subsequent runs will load the saved model

### Production Recommendations
- Replace dummy training with real HAM10000 dataset
- Implement transfer learning with pre-trained models (ResNet, MobileNet)
- Add data augmentation for better accuracy
- Use proper validation and test sets
- Implement model versioning and updates

## Installation

1. Install Python 3.8 or higher
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Run the application:
   ```bash
   python app.py
   ```

The AI model will be loaded automatically on startup.

## API Endpoints

### Authentication
- `POST /signup` - User registration
- `POST /signin` - User login

### AI Prediction
- `POST /predict` - Upload image for AI-powered skin disease prediction
- `POST /solution` - Get treatment solution for a disease

### Health Check
- `GET /health` - API health status

## Request/Response Examples

### Predict Disease (AI-Powered)
```
POST /predict
Content-Type: multipart/form-data
image: [image file]
```

Response:
```json
{
  "diseaseName": "Melanoma",
  "description": "Melanoma is the most serious type of skin cancer...",
  "confidence": 0.87
}
```

### Get Solution
```json
POST /solution
{
  "diseaseName": "Melanoma"
}
```

Response:
```json
{
  "diseaseName": "Melanoma",
  "solution": "1) Immediate surgical excision. 2) Sentinel lymph node biopsy if indicated. 3) Immunotherapy or targeted therapy for advanced cases. 4) Regular skin examinations. 5) Immediate dermatologist consultation required"
}
```

## Notes

- **AI Model**: Real CNN model for skin disease classification
- **Image Processing**: Automatic resizing and normalization
- **Confidence Scores**: Real prediction confidence from the model
- **Medical Disclaimer**: Results are for educational purposes only
- **Production**: Implement proper password hashing and database storage
