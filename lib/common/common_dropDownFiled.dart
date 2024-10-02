import 'package:flutter/material.dart';

class LabeledDropdown extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? selectedValue;
  final Function(String?) onChanged;

  const LabeledDropdown({
    Key? key,
    required this.label,
    required this.options,
    required this.onChanged,
    this.selectedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14.0, 
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8.0),  // Adds space between label and dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400, width: 1.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                icon: const Icon(Icons.arrow_drop_down),
                isExpanded: true,
                items: options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
