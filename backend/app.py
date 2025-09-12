from flask import Flask, request, jsonify
from flask_cors import CORS
import os
import uuid
from werkzeug.utils import secure_filename
import json
from datetime import datetime

app = Flask(__name__)
CORS(app)

# Configuration
UPLOAD_FOLDER = 'uploads'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'bmp'}
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024  # 16MB max file size

# Create upload directory if it doesn't exist
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

# In-memory storage for demo purposes (in production, use a database)
users_db = {}
sessions_db = {}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def generate_user_id():
    return str(uuid.uuid4())

def generate_session_token():
    return str(uuid.uuid4())

# Mock skin disease prediction data
SKIN_DISEASES = {
    'eczema': {
        'name': 'Eczema',
        'description': 'Eczema is a condition that causes the skin to become red, itchy, and inflamed. It can appear anywhere on the body and is often chronic.',
        'confidence': 0.92
    },
    'psoriasis': {
        'name': 'Psoriasis',
        'description': 'Psoriasis is a chronic autoimmune condition that causes rapid skin cell turnover, leading to thick, scaly patches on the skin.',
        'confidence': 0.88
    },
    'acne': {
        'name': 'Acne',
        'description': 'Acne is a common skin condition that occurs when hair follicles become plugged with oil and dead skin cells, causing pimples, blackheads, and whiteheads.',
        'confidence': 0.95
    },
    'dermatitis': {
        'name': 'Contact Dermatitis',
        'description': 'Contact dermatitis is a red, itchy rash caused by direct contact with a substance or an allergic reaction to it.',
        'confidence': 0.85
    },
    'melanoma': {
        'name': 'Melanoma',
        'description': 'Melanoma is a serious form of skin cancer that develops in the cells that produce melanin, the pigment that gives skin its color.',
        'confidence': 0.78
    }
}

# Mock treatment solutions
TREATMENT_SOLUTIONS = {
    'eczema': 'Treatment for eczema includes: 1) Moisturizing regularly with fragrance-free creams, 2) Using mild, unscented soaps, 3) Avoiding triggers like stress, certain foods, and irritants, 4) Topical corticosteroids for flare-ups, 5) Antihistamines for itching, 6) Wet wrap therapy for severe cases. Consult a dermatologist for personalized treatment.',
    'psoriasis': 'Treatment for psoriasis includes: 1) Topical treatments like corticosteroids and vitamin D analogues, 2) Phototherapy (light therapy), 3) Oral medications like methotrexate or cyclosporine, 4) Biologic drugs for severe cases, 5) Lifestyle changes including stress management, 6) Avoiding triggers like smoking and alcohol. Regular follow-up with a dermatologist is essential.',
    'acne': 'Treatment for acne includes: 1) Gentle cleansing twice daily with mild soap, 2) Over-the-counter treatments with benzoyl peroxide or salicylic acid, 3) Prescription topical treatments like retinoids, 4) Oral antibiotics for moderate to severe acne, 5) Hormonal therapy for women, 6) Avoiding picking or squeezing pimples, 7) Using non-comedogenic makeup and skincare products.',
    'dermatitis': 'Treatment for contact dermatitis includes: 1) Identifying and avoiding the trigger substance, 2) Gentle cleansing with mild soap, 3) Applying cool, wet compresses, 4) Using over-the-counter hydrocortisone cream, 5) Taking antihistamines for itching, 6) Moisturizing regularly, 7) Wearing protective clothing when necessary. See a doctor if symptoms persist.',
    'melanoma': 'Treatment for melanoma requires immediate medical attention: 1) Surgical removal of the tumor, 2) Sentinel lymph node biopsy, 3) Additional treatments may include immunotherapy, targeted therapy, chemotherapy, or radiation therapy, 4) Regular follow-up appointments for monitoring, 5) Sun protection and regular skin checks. Early detection is crucial for successful treatment.'
}

@app.route('/signup', methods=['POST'])
def signup():
    try:
        data = request.get_json()
        
        if not data or not all(key in data for key in ['name', 'email', 'password']):
            return jsonify({'error': 'Missing required fields'}), 400
        
        name = data['name'].strip()
        email = data['email'].strip().lower()
        password = data['password']
        
        # Basic validation
        if len(name) < 2:
            return jsonify({'error': 'Name must be at least 2 characters'}), 400
        
        if '@' not in email:
            return jsonify({'error': 'Invalid email format'}), 400
        
        if len(password) < 6:
            return jsonify({'error': 'Password must be at least 6 characters'}), 400
        
        # Check if user already exists
        if email in users_db:
            return jsonify({'error': 'User already exists with this email'}), 400
        
        # Create new user
        user_id = generate_user_id()
        user = {
            'id': user_id,
            'name': name,
            'email': email,
            'password': password,  # In production, hash the password
            'created_at': datetime.now().isoformat()
        }
        
        users_db[email] = user
        
        # Create session
        session_token = generate_session_token()
        sessions_db[session_token] = user_id
        
        return jsonify({
            'message': 'User created successfully',
            'user': {
                'id': user['id'],
                'name': user['name'],
                'email': user['email']
            },
            'session_token': session_token
        }), 201
        
    except Exception as e:
        return jsonify({'error': f'Server error: {str(e)}'}), 500

@app.route('/signin', methods=['POST'])
def signin():
    try:
        data = request.get_json()
        
        if not data or not all(key in data for key in ['email', 'password']):
            return jsonify({'error': 'Missing email or password'}), 400
        
        email = data['email'].strip().lower()
        password = data['password']
        
        # Check if user exists
        if email not in users_db:
            return jsonify({'error': 'Invalid email or password'}), 401
        
        user = users_db[email]
        
        # Check password (in production, use proper password hashing)
        if user['password'] != password:
            return jsonify({'error': 'Invalid email or password'}), 401
        
        # Create session
        session_token = generate_session_token()
        sessions_db[session_token] = user['id']
        
        return jsonify({
            'message': 'Login successful',
            'user': {
                'id': user['id'],
                'name': user['name'],
                'email': user['email']
            },
            'session_token': session_token
        }), 200
        
    except Exception as e:
        return jsonify({'error': f'Server error: {str(e)}'}), 500

@app.route('/predict', methods=['POST'])
def predict():
    try:
        if 'image' not in request.files:
            return jsonify({'error': 'No image file provided'}), 400
        
        file = request.files['image']
        
        if file.filename == '':
            return jsonify({'error': 'No image file selected'}), 400
        
        if file and allowed_file(file.filename):
            # Save the file
            filename = secure_filename(file.filename)
            file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            file.save(file_path)
            
            # Mock prediction logic (in production, use actual ML model)
            import random
            disease_key = random.choice(list(SKIN_DISEASES.keys()))
            disease_data = SKIN_DISEASES[disease_key]
            
            # Add some randomness to confidence for realism
            confidence = disease_data['confidence'] + random.uniform(-0.1, 0.05)
            confidence = max(0.5, min(0.99, confidence))  # Keep within reasonable bounds
            
            # Clean up the file after processing
            try:
                os.remove(file_path)
            except:
                pass
            
            return jsonify({
                'diseaseName': disease_data['name'],
                'description': disease_data['description'],
                'confidence': round(confidence, 2)
            }), 200
        else:
            return jsonify({'error': 'Invalid file type. Please upload a valid image file.'}), 400
            
    except Exception as e:
        return jsonify({'error': f'Server error: {str(e)}'}), 500

@app.route('/solution', methods=['POST'])
def solution():
    try:
        data = request.get_json()
        
        if not data or 'diseaseName' not in data:
            return jsonify({'error': 'Disease name is required'}), 400
        
        disease_name = data['diseaseName'].strip().lower()
        
        # Find matching disease in our database
        matching_disease = None
        for key, value in SKIN_DISEASES.items():
            if disease_name in value['name'].lower() or key in disease_name:
                matching_disease = key
                break
        
        if not matching_disease:
            return jsonify({'error': 'Disease not found in our database'}), 404
        
        solution_text = TREATMENT_SOLUTIONS.get(matching_disease, 'No treatment information available for this disease.')
        
        return jsonify({
            'diseaseName': SKIN_DISEASES[matching_disease]['name'],
            'solution': solution_text
        }), 200
        
    except Exception as e:
        return jsonify({'error': f'Server error: {str(e)}'}), 500

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy', 'message': 'Skin Disease Prediction API is running'}), 200

if __name__ == '__main__':
    print("Starting Skin Disease Prediction API...")
    print("Available endpoints:")
    print("- POST /signup")
    print("- POST /signin") 
    print("- POST /predict")
    print("- POST /solution")
    print("- GET /health")
    app.run(debug=True, host='0.0.0.0', port=5000)
