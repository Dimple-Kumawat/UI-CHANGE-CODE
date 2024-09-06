import 'package:flutter/material.dart';

class LabeledDropdown extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? selectedValue;
  final Function(String?) onChanged;
  final double spacing;

  const LabeledDropdown({
    Key? key,
    required this.label,
    required this.options,
    required this.onChanged,
    this.spacing = 0.0, // Set spacing to minimal
    this.selectedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // Ensure vertical alignment
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
        SizedBox(width: spacing), // Minimal spacing between label and dropdown
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue,
            icon: Icon(
              Icons.arrow_drop_down, // Dropdown arrow icon
              color: Colors.grey.shade700,
              size: 18.0, // Control the size of the dropdown arrow
            ),
            isDense: true, // Reduce the height and padding
            isExpanded: false, // Prevent the dropdown from taking too much space
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Align(
                  alignment: Alignment.centerLeft, // Align text to the left
                  child: Text(value),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
