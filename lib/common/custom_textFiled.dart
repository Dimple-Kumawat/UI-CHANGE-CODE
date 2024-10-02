import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String name;
  final bool readOnly;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final bool isRequired;

  const CustomTextField({
    Key? key,
    required this.name,
    this.initialValue,
    this.readOnly = false,
    this.onChanged,
    required this.label,
    this.isRequired = true, // Add this to show the asterisk conditionally
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label with a red asterisk if the field is required
          SizedBox(
            width: 100, // Adjust the width to align labels and fields properly
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                  if (isRequired) // Only show the asterisk if the field is required
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Colors.red, // Red asterisk for required fields
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20), // Space between label and field
          // Form Field
          Expanded(
            child: FormBuilderTextField(
              name: name,
              readOnly: readOnly,
              initialValue: initialValue,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 10.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 1.5,
                  ),
                ),
              ),
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
