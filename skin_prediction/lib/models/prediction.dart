class Prediction {
  final String diseaseName;
  final String description;
  final double confidence;

  Prediction({
    required this.diseaseName,
    required this.description,
    required this.confidence,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      diseaseName: json['diseaseName'] ?? '',
      description: json['description'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diseaseName': diseaseName,
      'description': description,
      'confidence': confidence,
    };
  }
}
