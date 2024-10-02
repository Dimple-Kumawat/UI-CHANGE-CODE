import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String name;
  final bool readOnly;
  final String? initialValue;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
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
      padding: const EdgeInsets.symmetric(vertical: 1.0), // Reduced padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start ,
        children: [
          Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: label, // Label text in black
                        style: const TextStyle(
                          color: Colors.black, // Label in black
                          fontSize: 12.0, // Smaller label size
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(
                        text: ' *', // Asterisk in red
                        style: TextStyle(
                          color: Colors.red, // Red asterisk
                          fontSize: 10.0, // Smaller asterisk size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
              height: 1.0), // Less space between label and text field
          FormBuilderTextField(
            name: name,
            readOnly: readOnly,
            initialValue: initialValue,
            decoration: InputDecoration(
              hintText: '', // No label inside the border
              contentPadding: const EdgeInsets.symmetric(
                vertical: 4.0, // Reduced vertical padding
                horizontal: 6.0, // Reduced horizontal padding
              ),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(6.0), // Smaller border radius
                borderSide: BorderSide(
                  color: Colors.grey.shade400, // Border color
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(6.0), // Smaller enabled border
                borderSide: BorderSide(
                  color: Colors.grey.shade400, // Border color when enabled
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(6.0), // Smaller focused border
                borderSide: const BorderSide(
                  color: Colors.blue, // Border color when focused
                  width: 1.5, // Narrower border width when focused
                ),
              ),
            ),
            style: const TextStyle(
              fontSize: 14.0, // Smaller input text size
            ),
          ),
        ],
      ),
    );
  }
}
