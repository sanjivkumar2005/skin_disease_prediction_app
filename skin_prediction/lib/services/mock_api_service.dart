import 'dart:io';
import 'dart:math';

class MockApiService {
  // Mock skin disease prediction data
  static final Map<String, Map<String, dynamic>> _skinDiseases = {
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
    },
    'rosacea': {
      'name': 'Rosacea',
      'description': 'Rosacea is a chronic skin condition that causes redness and visible blood vessels in your face. It may also produce small, red, pus-filled bumps.',
      'confidence': 0.82
    },
    'vitiligo': {
      'name': 'Vitiligo',
      'description': 'Vitiligo is a condition in which the skin loses its pigment cells, resulting in white patches on the skin.',
      'confidence': 0.75
    }
  };

  // Mock treatment solutions
  static final Map<String, String> _treatmentSolutions = {
    'eczema': 'Treatment for eczema includes: 1) Moisturizing regularly with fragrance-free creams, 2) Using mild, unscented soaps, 3) Avoiding triggers like stress, certain foods, and irritants, 4) Topical corticosteroids for flare-ups, 5) Antihistamines for itching, 6) Wet wrap therapy for severe cases. Consult a dermatologist for personalized treatment.',
    'psoriasis': 'Treatment for psoriasis includes: 1) Topical treatments like corticosteroids and vitamin D analogues, 2) Phototherapy (light therapy), 3) Oral medications like methotrexate or cyclosporine, 4) Biologic drugs for severe cases, 5) Lifestyle changes including stress management, 6) Avoiding triggers like smoking and alcohol. Regular follow-up with a dermatologist is essential.',
    'acne': 'Treatment for acne includes: 1) Gentle cleansing twice daily with mild soap, 2) Over-the-counter treatments with benzoyl peroxide or salicylic acid, 3) Prescription topical treatments like retinoids, 4) Oral antibiotics for moderate to severe acne, 5) Hormonal therapy for women, 6) Avoiding picking or squeezing pimples, 7) Using non-comedogenic makeup and skincare products.',
    'dermatitis': 'Treatment for contact dermatitis includes: 1) Identifying and avoiding the trigger substance, 2) Gentle cleansing with mild soap, 3) Applying cool, wet compresses, 4) Using over-the-counter hydrocortisone cream, 5) Taking antihistamines for itching, 6) Moisturizing regularly, 7) Wearing protective clothing when necessary. See a doctor if symptoms persist.',
    'melanoma': 'Treatment for melanoma requires immediate medical attention: 1) Surgical removal of the tumor, 2) Sentinel lymph node biopsy, 3) Additional treatments may include immunotherapy, targeted therapy, chemotherapy, or radiation therapy, 4) Regular follow-up appointments for monitoring, 5) Sun protection and regular skin checks. Early detection is crucial for successful treatment.',
    'rosacea': 'Treatment for rosacea includes: 1) Identifying and avoiding triggers like sun exposure, spicy foods, alcohol, and stress, 2) Gentle skincare routine with mild, non-abrasive cleansers, 3) Topical medications like metronidazole or azelaic acid, 4) Oral antibiotics for moderate to severe cases, 5) Laser therapy for visible blood vessels, 6) Sun protection with broad-spectrum sunscreen. Consult a dermatologist for proper management.',
    'vitiligo': 'Treatment for vitiligo includes: 1) Topical corticosteroids to help repigment the skin, 2) Topical calcineurin inhibitors, 3) Phototherapy (light therapy) with narrowband UVB, 4) Excimer laser therapy for small areas, 5) Depigmentation therapy for extensive cases, 6) Cosmetic camouflage techniques, 7) Psychological support and counseling. Treatment success varies and may take several months.'
  };

  // Mock user database
  static final Map<String, Map<String, dynamic>> _users = {};
  static final Map<String, String> _sessions = {};

  // Sign Up
  static Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      // Basic validation
      if (name.length < 2) {
        return {'error': 'Name must be at least 2 characters'};
      }
      
      if (!email.contains('@')) {
        return {'error': 'Invalid email format'};
      }
      
      if (password.length < 6) {
        return {'error': 'Password must be at least 6 characters'};
      }
      
      // Check if user already exists
      if (_users.containsKey(email.toLowerCase())) {
        return {'error': 'User already exists with this email'};
      }
      
      // Create new user
      final userId = _generateUserId();
      final user = {
        'id': userId,
        'name': name,
        'email': email.toLowerCase(),
        'password': password, // In production, hash the password
        'created_at': DateTime.now().toIso8601String()
      };
      
      _users[email.toLowerCase()] = user;
      
      // Create session
      final sessionToken = _generateSessionToken();
      _sessions[sessionToken] = userId;
      
      return {
        'message': 'User created successfully',
        'user': {
          'id': user['id'],
          'name': user['name'],
          'email': user['email']
        },
        'session_token': sessionToken
      };
    } catch (e) {
      return {'error': 'Server error: $e'};
    }
  }

  // Sign In
  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      final emailKey = email.toLowerCase();
      
      // Check if user exists
      if (!_users.containsKey(emailKey)) {
        return {'error': 'Invalid email or password'};
      }
      
      final user = _users[emailKey]!;
      
      // Check password
      if (user['password'] != password) {
        return {'error': 'Invalid email or password'};
      }
      
      // Create session
      final sessionToken = _generateSessionToken();
      _sessions[sessionToken] = user['id'];
      
      return {
        'message': 'Login successful',
        'user': {
          'id': user['id'],
          'name': user['name'],
          'email': user['email']
        },
        'session_token': sessionToken
      };
    } catch (e) {
      return {'error': 'Server error: $e'};
    }
  }

  // Predict Disease
  static Future<Map<String, dynamic>> predictDisease(File imageFile) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      // Mock prediction logic - randomly select a disease
      final random = Random();
      final diseaseKeys = _skinDiseases.keys.toList();
      final diseaseKey = diseaseKeys[random.nextInt(diseaseKeys.length)];
      final diseaseData = _skinDiseases[diseaseKey]!;
      
      // Add some randomness to confidence for realism
      final baseConfidence = diseaseData['confidence'] as double;
      final confidence = baseConfidence + random.nextDouble() * 0.1 - 0.05;
      final finalConfidence = confidence.clamp(0.5, 0.99);
      
      return {
        'diseaseName': diseaseData['name'],
        'description': diseaseData['description'],
        'confidence': finalConfidence
      };
    } catch (e) {
      return {'error': 'Server error: $e'};
    }
  }

  // Get Solution
  static Future<Map<String, dynamic>> getSolution(String diseaseName) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      final diseaseKey = diseaseName.toLowerCase();
      
      // Find matching disease in our database
      String? matchingKey;
      for (final key in _skinDiseases.keys) {
        if (diseaseKey.contains(key) || key.contains(diseaseKey)) {
          matchingKey = key;
          break;
        }
      }
      
      if (matchingKey == null) {
        return {'error': 'Disease not found in our database'};
      }
      
      final solution = _treatmentSolutions[matchingKey] ?? 'No treatment information available for this disease.';
      
      return {
        'diseaseName': _skinDiseases[matchingKey]!['name'],
        'solution': solution
      };
    } catch (e) {
      return {'error': 'Server error: $e'};
    }
  }

  // Helper methods
  static String _generateUserId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static String _generateSessionToken() {
    return DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(1000).toString();
  }
}
