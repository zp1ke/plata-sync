import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_icons.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/utils/numbers.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

class CalculatorKeyboard extends StatelessWidget {
  final TextEditingController controller;
  final void Function(double) onDone;

  const CalculatorKeyboard({
    super.key,
    required this.controller,
    required this.onDone,
  });

  void _insertText(String text) {
    final selection = controller.selection;
    final currentText = controller.text;
    final newText = selection.isValid
        ? currentText.replaceRange(selection.start, selection.end, text)
        : currentText + text;

    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.isValid
            ? selection.start + text.length
            : newText.length,
      ),
    );
  }

  void _backspace() {
    final selection = controller.selection;
    final currentText = controller.text;

    if (selection.isValid && !selection.isCollapsed) {
      final newText = currentText.replaceRange(
        selection.start,
        selection.end,
        '',
      );
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selection.start),
      );
    } else if (currentText.isNotEmpty) {
      final offset = selection.isValid ? selection.start : currentText.length;
      if (offset > 0) {
        final newText = currentText.replaceRange(offset - 1, offset, '');
        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: offset - 1),
        );
      }
    }
  }

  void _clear() {
    controller.clear();
  }

  double _calculate() {
    try {
      if (controller.text.isEmpty) return .0;

      final eval = evaluateExpression(controller.text);

      // Format result: remove trailing .0 if integer
      String result = eval.toString();
      if (result.endsWith('.0')) {
        result = result.substring(0, result.length - 2);
      }

      controller.text = result;
      controller.selection = TextSelection.collapsed(offset: result.length);

      return eval;
    } catch (e) {
      // Ignore errors or show feedback?
      // For now, just don't update if invalid
      return .0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppL10n.of(context);

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1
          Row(
            children: [
              _buildKey(context, 'C', color: colorScheme.error, onTap: _clear),
              _buildKey(context, '/', onTap: () => _insertText('/')),
              _buildKey(context, '*', onTap: () => _insertText('*')),
              _buildKey(
                context,
                '⌫',
                icon: AppIcons.backDelete,
                onTap: _backspace,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          // Row 2
          Row(
            children: [
              _buildKey(context, '7', onTap: () => _insertText('7')),
              _buildKey(context, '8', onTap: () => _insertText('8')),
              _buildKey(context, '9', onTap: () => _insertText('9')),
              _buildKey(context, '-', onTap: () => _insertText('-')),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          // Row 3
          Row(
            children: [
              _buildKey(context, '4', onTap: () => _insertText('4')),
              _buildKey(context, '5', onTap: () => _insertText('5')),
              _buildKey(context, '6', onTap: () => _insertText('6')),
              _buildKey(context, '+', onTap: () => _insertText('+')),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          // Row 4
          Row(
            children: [
              _buildKey(context, '1', onTap: () => _insertText('1')),
              _buildKey(context, '2', onTap: () => _insertText('2')),
              _buildKey(context, '3', onTap: () => _insertText('3')),
              _buildKey(
                context,
                '=',
                color: colorScheme.primaryContainer,
                textColor: colorScheme.onPrimaryContainer,
                onTap: _calculate,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          // Row 5
          Row(
            children: [
              _buildKey(context, '0', flex: 2, onTap: () => _insertText('0')),
              _buildKey(context, '.', onTap: () => _insertText('.')),
              _buildKey(
                context,
                l10n.done,
                icon: AppIcons.check,
                color: colorScheme.primary,
                textColor: colorScheme.onPrimary,
                onTap: () {
                  final value = _calculate(); // Calculate before closing
                  onDone(value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(
    BuildContext context,
    String label, {
    Widget? icon,
    VoidCallback? onTap,
    Color? color,
    Color? textColor,
    int flex = 1,
  }) {
    final theme = Theme.of(context);
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        child: Material(
          color: color ?? theme.colorScheme.surfaceContainerHighest,
          borderRadius: AppSizing.borderRadiusSm,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppSizing.borderRadiusSm,
            child: Container(
              height: AppSizing.avatarLg,
              alignment: Alignment.center,
              child:
                  icon ??
                  Text(
                    label,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
