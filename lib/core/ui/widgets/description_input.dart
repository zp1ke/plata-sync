import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../resources/app_icons.dart';
import 'input_decoration.dart';

/// A shared widget for description input fields with sentence capitalization.
/// Used for account and category descriptions.
class DescriptionInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final TextInputAction? textInputAction;
  final int maxLength;
  final int maxLines;

  const DescriptionInput({
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.textInputAction = TextInputAction.next,
    this.maxLength = 200,
    this.maxLines = 2,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      textCapitalization: TextCapitalization.sentences,
      decoration: inputDecorationWithPrefixIcon(
        labelText: '$labelText (${AppL10n.of(context).optional})',
        hintText: hintText,
        prefixIcon: prefixIcon ?? AppIcons.descriptionXs,
      ),
      maxLength: maxLength,
      maxLines: maxLines,
    );
  }
}
