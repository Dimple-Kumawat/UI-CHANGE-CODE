import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class  StuTextField extends StatelessWidget {
  final String label;
  final String name;
  final bool readOnly;
  final String? initialValue;
  final ValueChanged<String>? onChanged;

  const  StuTextField({
    Key? key,
    required this.name,
    this.initialValue,
    this.readOnly = false,
    this.onChanged,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label, // Label displayed above the text field
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8.0), // Space between label and text field
          FormBuilderTextField(
            name: name,
            readOnly: readOnly,
            initialValue: initialValue,
         //   onChanged: onChanged,
            decoration: InputDecoration(
              hintText: '', // No label inside the border
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 20.0, // Padding inside the text field
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0), // Rounded border
                borderSide: BorderSide(
                  color: Colors.grey.shade400, // Border color
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0), // Rounded enabled border
                borderSide: BorderSide(
                  color: Colors.grey.shade400, // Border color when enabled
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0), // Rounded focused border
                borderSide: const BorderSide(
                  color: Colors.blue, // Border color when focused
                  width: 2.0,
                ),
              ),
            ),
            style: const TextStyle(
              fontSize: 16.0, // Input text size
            ),
          ),
        ],
      ),
    );
  }
}
