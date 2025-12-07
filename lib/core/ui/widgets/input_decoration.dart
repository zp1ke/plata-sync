import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';

InputDecoration inputDecorationWithPrefixIcon({
  String? labelText,
  String? helperText,
  String? hintText,
  Widget? prefixIcon,
  double? iconSize,
  InputBorder? border,
  bool? filled,
}) {
  return InputDecoration(
    prefixIcon: prefixIcon != null
        ? Container(margin: AppSpacing.paddingHorizontalSm, child: prefixIcon)
        : null,
    prefixIconConstraints: prefixIcon != null
        ? BoxConstraints.tight(
            Size(
              iconSize ?? AppSizing.avatarMd,
              iconSize ?? AppSizing.avatarMd,
            ),
          )
        : null,
    labelText: labelText,
    helperText: helperText,
    hintText: hintText,
    border: border,
    filled: filled,
  );
}
