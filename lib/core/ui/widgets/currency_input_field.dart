import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A text form field specifically designed for currency input.
/// Accepts decimal numbers with up to 2 decimal places and optional negative sign.
class CurrencyInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? helperText;
  final bool required;
  final String? Function(String?)? validator;
  final bool allowNegative;
  final String currencySymbol;
  final TextInputAction? textInputAction;

  const CurrencyInputField({
    required this.controller,
    required this.label,
    this.helperText,
    this.required = false,
    this.validator,
    this.allowNegative = true,
    this.currencySymbol = '\$',
    this.textInputAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
        signed: allowNegative,
      ),
      textInputAction: textInputAction,
      textAlign: TextAlign.end,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          allowNegative
              ? RegExp(r'^-?\d*\.?\d{0,2}')
              : RegExp(r'^\d*\.?\d{0,2}'),
        ),
      ],
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        border: const OutlineInputBorder(),
        prefixText: '$currencySymbol ',
        helperText: helperText,
      ),
      validator: validator ?? (value) => _defaultValidator(value),
    );
  }

  String? _defaultValidator(String? value) {
    if (required && (value == null || value.trim().isEmpty)) {
      return 'This field is required';
    }
    if (value != null && value.trim().isNotEmpty) {
      final amount = double.tryParse(value.trim());
      if (amount == null) {
        return 'Invalid amount format';
      }
    }
    return null;
  }

  /// Helper method to get the value in cents from the controller
  int? getValueInCents() {
    final text = controller.text.trim();
    if (text.isEmpty) return null;
    final amount = double.tryParse(text);
    if (amount == null) return null;
    return (amount * 100).round();
  }

  /// Helper method to set the value from cents
  void setValueFromCents(int cents) {
    controller.text = (cents / 100).toStringAsFixed(2);
  }
}
