# Skin Disease Prediction Backend

This is the Flask backend API for the Skin Disease Prediction mobile application.

## Features

- User registration and authentication
- Image upload and skin disease prediction
- Treatment solution recommendations
- CORS enabled for mobile app integration

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

## Notes

- This is a demo implementation with mock data
- In production, implement proper password hashing
- Use a real database instead of in-memory storage
- Integrate with actual ML models for predictions
- Add proper error handling and logging
