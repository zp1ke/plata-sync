import 'package:flutter/material.dart';
import 'input_decoration.dart';

/// A shared widget for name input fields with capitalized text input.
/// Used for account and category names.
class NameInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String errorText;
  final Widget prefixIcon;
  final TextInputAction? textInputAction;
  final int maxLength;

  const NameInput({
    required this.controller,
    required this.labelText,
    required this.errorText,
    required this.prefixIcon,
    this.textInputAction = TextInputAction.next,
    this.maxLength = 100,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      textCapitalization: TextCapitalization.words,
      decoration: inputDecorationWithPrefixIcon(
        labelText: '$labelText *',
        prefixIcon: prefixIcon,
      ),
      maxLength: maxLength,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return errorText;
        }
        return null;
      },
    );
  }
}
