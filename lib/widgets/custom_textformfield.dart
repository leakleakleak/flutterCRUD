import 'package:flutter/material.dart';

class CustomeTextFormField extends StatelessWidget {
  const CustomeTextFormField(
      {super.key, required this.controller, required this.textLabel});

  final TextEditingController controller;
  final String textLabel;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a text';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: textLabel,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
