# Skin Disease Prediction App

A Flutter mobile application that uses AI to predict skin diseases from uploaded or captured images. The app provides instant analysis, detailed descriptions, and treatment recommendations.

## Features

### Authentication
- **Sign Up**: New user registration with email and password
- **Sign In**: Secure login for existing users
- **Session Management**: Persistent login sessions

### Image Analysis
- **Gallery Upload**: Select images from device gallery
- **Camera Capture**: Take photos directly using device camera
- **Image Processing**: Optimized image handling and compression

### AI Prediction
- **Disease Detection**: AI-powered skin disease identification
- **Confidence Scores**: Detailed confidence levels for predictions
- **Disease Descriptions**: Comprehensive information about detected conditions

### Treatment Solutions
- **Personalized Recommendations**: Treatment solutions based on detected disease
- **Professional Guidance**: Medical advice and treatment options
- **Educational Content**: Detailed information about skin conditions

## Tech Stack

### Frontend (Flutter)
- **Flutter SDK**: Cross-platform mobile development
- **image_picker**: Gallery and camera integration
- **http**: API communication
- **shared_preferences**: Local data storage
- **Material Design 3**: Modern UI components

### Backend (Flask)
- **Flask**: Python web framework
- **Flask-CORS**: Cross-origin resource sharing
- **Werkzeug**: WSGI utilities
- **Pillow**: Image processing
- **RESTful API**: Clean API design

## Project Structure

```
skin_prediction/
├── lib/
│   ├── models/
│   │   ├── user.dart
│   │   └── prediction.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   └── auth_service.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── auth_screen.dart
│   │   ├── signin_screen.dart
│   │   ├── signup_screen.dart
│   │   ├── home_screen.dart
│   │   ├── result_screen.dart
│   │   └── solution_screen.dart
│   └── main.dart
└── pubspec.yaml

backend/
├── app.py
├── requirements.txt
└── README.md
```

## Getting Started

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Python 3.8 or higher
- Android Studio / VS Code
- Android/iOS device or emulator

### Flutter App Setup

1. **Install Dependencies**
   ```bash
   cd skin_prediction
   flutter pub get
   ```

2. **Update API URL**
   - Open `lib/services/api_service.dart`
   - Update the `baseUrl` to match your backend server

3. **Run the App**
   ```bash
   flutter run
   ```

### Backend Setup

1. **Install Python Dependencies**
   ```bash
   cd backend
   pip install -r requirements.txt
   ```

2. **Run the Backend Server**
   ```bash
   python app.py
   ```

The API will be available at `http://localhost:5000`

## App Flow

1. **Splash Screen**: App initialization and authentication check
2. **Authentication**: Sign up or sign in to access the app
3. **Home Screen**: Upload or capture an image for analysis
4. **Result Screen**: View prediction results with confidence scores
5. **Solution Screen**: Get detailed treatment recommendations

## API Endpoints

### Authentication
- `POST /signup` - User registration
- `POST /signin` - User login

### Prediction
- `POST /predict` - Upload image for analysis
- `POST /solution` - Get treatment recommendations

### Health Check
- `GET /health` - API status

## Screenshots

The app features a modern, intuitive interface with:
- Clean authentication screens
- Easy image selection and capture
- Detailed prediction results
- Comprehensive treatment information

## Key Features

### Image Handling
- Support for multiple image formats (PNG, JPG, JPEG, GIF, BMP)
- Automatic image compression and optimization
- Gallery and camera integration

### User Experience
- Material Design 3 components
- Smooth navigation between screens
- Loading states and error handling
- Responsive design for different screen sizes

### Security
- Input validation and sanitization
- Secure API communication
- Session management
- Error handling and user feedback

## Development Notes

### Flutter Dependencies
- `http: ^1.1.0` - API communication
- `image_picker: ^1.0.4` - Image selection
- `shared_preferences: ^2.2.2` - Local storage
- `path_provider: ^2.1.1` - File operations

### Backend Dependencies
- `Flask==2.3.3` - Web framework
- `Flask-CORS==4.0.0` - CORS support
- `Werkzeug==2.3.7` - WSGI utilities
- `Pillow==10.0.1` - Image processing

## Future Enhancements

- Real ML model integration
- Database implementation
- User profile management
- Prediction history
- Offline support
- Push notifications
- Multi-language support

## Disclaimer

This application is for educational and demonstration purposes. The predictions and treatment recommendations should not replace professional medical advice. Always consult with healthcare professionals for proper diagnosis and treatment.

## License

This project is open source and available under the MIT License.