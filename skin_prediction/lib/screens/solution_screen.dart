import 'package:flutter/material.dart';
import 'dart:math';
import '../services/api_service.dart';

class SolutionScreen extends StatefulWidget {
  final String diseaseName;
  
  const SolutionScreen({super.key, required this.diseaseName});

  @override
  State<SolutionScreen> createState() => _SolutionScreenState();
}

class _SolutionScreenState extends State<SolutionScreen> {
  String? _solution;
  bool _isLoading = true;
  String? _error;
  double _diseaseCriticality = 0.0;

  @override
  void initState() {
    super.initState();
    _getSolution();
  }

  Future<void> _getSolution() async {
    try {
      final response = await ApiService.getSolution(widget.diseaseName);
      
      if (response.containsKey('error')) {
        setState(() {
          _error = response['error'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _solution = response['solution'] ?? 'No solution available for this disease.';
          // Generate a random criticality score for demonstration
          _diseaseCriticality = Random().nextDouble() * 0.8 + 0.2; // Between 0.2 and 1.0
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }


  Widget _buildCriticalityGraph() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Disease Criticality',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9478E6),
            ),
          ),
          const SizedBox(height: 20),
          
          // Progress bar
          Container(
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _diseaseCriticality,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _diseaseCriticality > 0.7
                        ? [Colors.red.shade400, Colors.red.shade600]
                        : _diseaseCriticality > 0.4
                            ? [Colors.orange.shade400, Colors.orange.shade600]
                            : [Colors.green.shade400, Colors.green.shade600],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 10),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(_diseaseCriticality * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _diseaseCriticality > 0.7
                      ? Colors.red.shade600
                      : _diseaseCriticality > 0.4
                          ? Colors.orange.shade600
                          : Colors.green.shade600,
                ),
              ),
              Text(
                _diseaseCriticality > 0.7
                    ? 'High Risk'
                    : _diseaseCriticality > 0.4
                        ? 'Medium Risk'
                        : 'Low Risk',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _diseaseCriticality > 0.7
                      ? Colors.red.shade600
                      : _diseaseCriticality > 0.4
                          ? Colors.orange.shade600
                          : Colors.green.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<String> _parseSolutionToBullets(String solution) {
    // Split by common sentence endings and filter out empty strings
    List<String> sentences = solution
        .split(RegExp(r'[.!?]+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    
    // If no sentences found, return the original text as a single bullet
    if (sentences.isEmpty) {
      return [solution];
    }
    
    return sentences;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Treatment Solution',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: const Color(0xFF9478E6),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Loading treatment solution...',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF9478E6),
                      ),
                    ),
                  ],
                ),
              )
            : _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 80,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Error',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _error!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9478E6),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0,
                            ),
                            child: const Text('Go Back'),
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF9478E6),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.medical_services,
                                size: 60,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'Treatment Solution',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'For ${widget.diseaseName}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Disease criticality graph
                        _buildCriticalityGraph(),
                        
                        const SizedBox(height: 30),
                        
                        // Solution content
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.tips_and_updates,
                                    color: const Color(0xFF9478E6),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Recommended Treatment',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF9478E6),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              
                              // Convert solution to numbered list
                              ...(_solution != null 
                                  ? _parseSolutionToBullets(_solution!)
                                      .asMap()
                                      .entries
                                      .map((entry) => Padding(
                                            padding: const EdgeInsets.only(bottom: 12),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(top: 6, right: 12),
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF9478E6),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '${entry.key + 1}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    entry.value,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black87,
                                                      height: 1.6,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList()
                                  : [const SizedBox.shrink()]),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Disclaimer
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.amber.shade300,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.warning_amber,
                                color: Colors.amber.shade700,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Disclaimer: This information is for educational purposes only and should not replace professional medical advice. Please consult a healthcare professional for proper diagnosis and treatment.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.amber.shade800,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: OutlinedButton.icon(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.arrow_back, color: Color(0xFF9478E6)),
                                  label: const Text(
                                    'Back to Result',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF9478E6),
                                    side: const BorderSide(color: Color(0xFF9478E6), width: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.popUntil(context, (route) => route.isFirst);
                                  },
                                  icon: const Icon(Icons.home, color: Colors.white),
                                  label: const Text(
                                    'Home',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF9478E6),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
