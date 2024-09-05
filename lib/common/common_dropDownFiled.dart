import 'package:flutter/material.dart';

class LabeledDropdown extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? initialValue;
  final Function(String?) onChanged;
  final TextStyle? labelStyle;
  final TextStyle? dropdownTextStyle;
  final double spaceBetweenLabelAndDropdown;

  const LabeledDropdown({
    Key? key,
    required this.label,
    required this.options,
    required this.onChanged,
    this.initialValue,
    this.labelStyle,
    this.dropdownTextStyle,
    this.spaceBetweenLabelAndDropdown = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: labelStyle ?? Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(height: spaceBetweenLabelAndDropdown),
        DropdownButtonFormField<String>(
          value: initialValue,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          dropdownColor: Colors.white, // Background color of dropdown items
          style: dropdownTextStyle ?? Theme.of(context).textTheme.bodyText2,
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
          icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade700), // Dropdown icon
          isExpanded: true, // Makes the dropdown take up the full width
        ),
      ],
    );
  }
}
