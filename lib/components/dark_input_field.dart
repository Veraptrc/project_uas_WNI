import 'package:flutter/material.dart';

class DarkInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final bool obscureText;

  const DarkInputField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      child: TextField(
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          contentPadding: const EdgeInsets.only(left: 24),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: const BorderRadius.all(
              Radius.circular(100),
            ),
          ),
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: const BorderRadius.all(
              Radius.circular(100),
            ),
          ),
        ),
        obscureText: obscureText,
      ),
    );
  }
}
