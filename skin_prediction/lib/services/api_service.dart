import 'dart:io';
import 'mock_api_service.dart';

class ApiService {
  // Using mock API service for offline functionality
  // To use real backend, replace MockApiService with actual HTTP calls
  
  // Sign Up
  static Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return await MockApiService.signUp(
      name: name,
      email: email,
      password: password,
    );
  }

  // Sign In
  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    return await MockApiService.signIn(
      email: email,
      password: password,
    );
  }

  // Predict Disease
  static Future<Map<String, dynamic>> predictDisease(File imageFile) async {
    return await MockApiService.predictDisease(imageFile);
  }

  // Get Solution
  static Future<Map<String, dynamic>> getSolution(String diseaseName) async {
    return await MockApiService.getSolution(diseaseName);
  }
}
