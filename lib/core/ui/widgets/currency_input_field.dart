import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plata_sync/core/ui/resources/app_icons.dart';
import 'package:plata_sync/core/ui/widgets/calculator_keyboard.dart';
import 'package:plata_sync/core/ui/widgets/input_decoration.dart';
import 'package:plata_sync/core/utils/numbers.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

/// A text form field specifically designed for currency input.
class CurrencyInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? helperText;
  final bool required;
  final String? Function(String?)? validator;
  final bool allowNegative;
  final Widget? currencyWidget;
  final TextInputAction? textInputAction;

  const CurrencyInputField({
    required this.controller,
    required this.label,
    this.helperText,
    this.required = false,
    this.validator,
    this.allowNegative = true,
    this.currencyWidget,
    this.textInputAction,
    super.key,
  });

  void _showCalculator(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CalculatorKeyboard(
          controller: controller,
          onDone: (value) {
            controller.text = value.toStringAsFixed(2);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      // Hide system keyboard but show cursor
      readOnly: true,
      showCursor: true,
      onTap: () => _showCalculator(context),
      keyboardType: TextInputType.none,
      textInputAction: textInputAction,
      textAlign: TextAlign.end,
      // Allow operators in case of paste, but mainly controlled by custom keyboard
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[0-9+\-*/.\s]*$')),
      ],
      decoration: inputDecorationWithPrefixIcon(
        labelText: required ? '$label *' : label,
        prefixIcon: currencyWidget ?? AppIcons.currencyXs,
        helperText: helperText,
      ),
      validator: validator ?? (value) => _defaultValidator(value, context),
    );
  }

  String? _defaultValidator(String? value, BuildContext context) {
    if (required && (value == null || value.trim().isEmpty)) {
      return AppL10n.of(context).fieldRequiredError;
    }
    if (value != null && value.trim().isNotEmpty) {
      // Try to calculate first in case there's a pending expression
      try {
        evaluateExpression(value);
      } catch (e) {
        return AppL10n.of(context).invalidAmountError;
      }
    }
    return null;
  }

  /// Helper method to get the value in cents from the controller
  int? getValueInCents() {
    final text = controller.text.trim();
    if (text.isEmpty) return null;

    try {
      final eval = evaluateExpression(text);
      return (eval * 100).round();
    } catch (e) {
      return null;
    }
  }

  /// Helper method to set the value from cents
  void setValueFromCents(int cents) {
    controller.text = (cents / 100).toStringAsFixed(2);
  }
}
