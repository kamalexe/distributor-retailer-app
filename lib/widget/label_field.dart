import 'package:flutter/material.dart';

class LabelTextField extends StatelessWidget {
  const LabelTextField({super.key, required this.label, required this.controller, required this.validator});

  final String label;
  final TextEditingController controller;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(2),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LabelDropdown extends StatelessWidget {
  const LabelDropdown({super.key, required this.label, required this.items, required this.value, required this.onChanged, this.valueMap});

  final String label;
  final List<String> items;
  final String? value;
  final void Function(String?) onChanged;
  final Map<String, String>? valueMap;

  @override
  Widget build(BuildContext context) {
    // Build dropdown items
    final List<DropdownMenuItem<String>> dropdownItems = valueMap != null
        ? valueMap!.entries.map((entry) => DropdownMenuItem<String>(value: entry.key, child: Text(entry.value))).toList()
        : items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList();

    // Validate value: must exist in the keys
    final validValue = dropdownItems.any((item) => item.value == value) ? value : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: validValue,
            items: dropdownItems,
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(2),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
