# Skin Disease Prediction App - Setup Guide

This guide will help you set up and run the Skin Disease Prediction application with Flutter frontend and Flask backend.

## Quick Start

### 1. Flutter App Setup

```bash
# Navigate to Flutter project
cd skin_prediction

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### 2. Backend Setup

```bash
# Navigate to backend directory
cd backend

# Install Python dependencies
pip install -r requirements.txt

# Run the Flask server
python app.py
```

## Detailed Setup

### Prerequisites

- **Flutter SDK** (3.9.0 or higher)
- **Dart SDK** (comes with Flutter)
- **Python** (3.8 or higher)
- **Android Studio** or **VS Code** with Flutter extensions
- **Android/iOS device** or emulator

### Flutter App Configuration

1. **Update API URL** (if needed):
   - Open `skin_prediction/lib/services/api_service.dart`
   - Change `baseUrl` from `'http://localhost:5000'` to your backend URL
   - For Android emulator, use `'http://10.0.2.2:5000'`
   - For physical device, use your computer's IP address

2. **Platform-specific setup**:

   **Android:**
   - Add camera permissions in `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.CAMERA" />
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
   ```

   **iOS:**
   - Add camera permissions in `ios/Runner/Info.plist`:
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>This app needs camera access to capture skin images for analysis.</string>
   <key>NSPhotoLibraryUsageDescription</key>
   <string>This app needs photo library access to select skin images for analysis.</string>
   ```

### Backend Configuration

1. **Install Python dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

2. **Run the server**:
   ```bash
   python app.py
   ```

3. **Verify the API**:
   - Open `http://localhost:5000/health` in your browser
   - You should see: `{"status": "healthy", "message": "Skin Disease Prediction API is running"}`

## Testing the App

### 1. Start the Backend
```bash
cd backend
python app.py
```

### 2. Start the Flutter App
```bash
cd skin_prediction
flutter run
```

### 3. Test the Flow
1. **Sign Up**: Create a new account
2. **Sign In**: Login with your credentials
3. **Upload Image**: Select or capture an image
4. **View Results**: See the prediction and confidence score
5. **Get Solution**: View treatment recommendations

## Troubleshooting

### Common Issues

1. **Connection Refused Error**:
   - Make sure the Flask server is running
   - Check the API URL in `api_service.dart`
   - For Android emulator, use `10.0.2.2:5000` instead of `localhost:5000`

2. **Camera Permission Denied**:
   - Check device settings for camera permissions
   - Ensure permissions are added to AndroidManifest.xml or Info.plist

3. **Image Upload Fails**:
   - Check file size (max 16MB)
   - Ensure image format is supported (PNG, JPG, JPEG, GIF, BMP)

4. **Flutter Build Errors**:
   - Run `flutter clean` and `flutter pub get`
   - Check Flutter and Dart SDK versions

### API Testing

You can test the API endpoints using curl:

```bash
# Health check
curl http://localhost:5000/health

# Sign up
curl -X POST http://localhost:5000/signup \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","password":"password123"}'

# Sign in
curl -X POST http://localhost:5000/signin \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

## Development Notes

- The backend uses mock data for predictions
- In production, integrate with real ML models
- Implement proper database storage
- Add password hashing and security measures
- Use environment variables for configuration

## Support

If you encounter any issues:
1. Check the console logs for error messages
2. Verify all dependencies are installed
3. Ensure both frontend and backend are running
4. Check network connectivity and API URLs
