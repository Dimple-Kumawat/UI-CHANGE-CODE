import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final List<String> testTypes = ['Periodic Test 1', 'Midterm'];
  final List<String> termOptions = ['Term 1', 'Term 2'];

  String? selectedTestTypeForFirstDropdown; // Initial state set to null
  String? selectedTermForSecondDropdown; // Initial state set to null

  // Mock result data for each test and term
  final Map<String, Map<String, List<Map<String, dynamic>>>> resultData = {
    'Periodic Test 1': {
      'Term 1': [
        {'subject': 'English', 'type': 'Periodic Test', 'score': '24/40'},
        {'subject': 'Hindi', 'type': 'Portfolio', 'score': '5/5'},
        {'subject': 'Hindi', 'type': 'Subject Enrichment', 'score': '2/5'},
        {'subject': 'Hindi', 'type': 'Term', 'score': '76/80'},
      ],
      'Term 2': [
        {'subject': 'Math', 'type': 'Periodic Test', 'score': '30/40'},
      ],
    },
    'Midterm': {
      'Term 1': [
        {'subject': 'Hindi', 'type': 'Portfolio', 'score': '5/5'},
        {'subject': 'Hindi', 'type': 'Subject Enrichment', 'score': '2/5'},
        {'subject': 'Hindi', 'type': 'Term', 'score': '76/80'},
      ],
      'Term 2': [
        {'subject': 'Science', 'type': 'Midterm Exam', 'score': '50/60'},
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 80.h,
        title: Text(
          "Result",
          style: TextStyle(fontSize: 20.sp, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 110),
              // First Dropdown for Test Type
              _buildDropdown('Select Test Type', selectedTestTypeForFirstDropdown, testTypes, (value) {
                setState(() {
                  selectedTestTypeForFirstDropdown = value;
                  // Reset second dropdown when the first dropdown changes
                  selectedTermForSecondDropdown = null;
                });
              }),
              const SizedBox(height: 10),
              // Display results dynamically for the first dropdown (Test Type)
              if (selectedTestTypeForFirstDropdown != null) 
                _buildResultsForFirstDropdown(selectedTestTypeForFirstDropdown!),
              
              const SizedBox(height: 20),
              
              // Second Dropdown for Term Options (Enabled only if Test Type is selected)
              _buildDropdown('Select Term', selectedTermForSecondDropdown, selectedTestTypeForFirstDropdown != null ? termOptions : [], (value) {
                setState(() {
                  selectedTermForSecondDropdown = value;
                });
              }),
              
              const SizedBox(height: 10),
              
              // Display results dynamically for the second dropdown (Term)
              if (selectedTestTypeForFirstDropdown != null && selectedTermForSecondDropdown != null) 
                _buildResultsForSecondDropdown(selectedTestTypeForFirstDropdown!, selectedTermForSecondDropdown!),
            ],
          ),
        ),
      ),
    );
  }

  // Dropdown Builder
  Widget _buildDropdown(String label, String? selectedValue, List<String> options, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(label), // Show label when no selection is made
          value: selectedValue,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          iconSize: 24,
          isExpanded: true,
          style: TextStyle(fontSize: 16.sp, color: Colors.black),
          items: options.isNotEmpty
              ? options.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList()
              : [], // No items when no test type is selected
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Build Results Based on Selection for First Dropdown
  Widget _buildResultsForFirstDropdown(String selectedTestType) {
    final results = resultData[selectedTestType]?['Term 1'] ?? [];

    if (results.isEmpty) {
      return const Center(
        child: Text("No results available"),
      );
    }

    return Column(
      children: results.map((result) {
        return _buildResultCard(result['subject'], result['type'], result['score']);
      }).toList(),
    );
  }

  // Build Results Based on Selection for Second Dropdown
  Widget _buildResultsForSecondDropdown(String selectedTestType, String selectedTerm) {
    final results = resultData[selectedTestType]?[selectedTerm] ?? [];

    if (results.isEmpty) {
      return const Center(
        child: Text("No results available"),
      );
    }

    return Column(
      children: results.map((result) {
        return _buildResultCard(result['subject'], result['type'], result['score']);
      }).toList(),
    );
  }

  // Result Card
  Widget _buildResultCard(String subject, String type, String score) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              subject,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              type,
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              score,
              style: TextStyle(fontSize: 16.sp, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
