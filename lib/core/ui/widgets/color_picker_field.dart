import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/dialog.dart';
import 'package:plata_sync/core/utils/colors.dart';

/// A form field that allows users to pick a color from a predefined palette.
class ColorPickerField extends StatelessWidget {
  final String label;
  final String? helperText;
  final String value;
  final ValueChanged<String> onChanged;

  const ColorPickerField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.helperText,
    super.key,
  });

  static final List<String> predefinedColors = [
    // Reds & Pinks
    'FFEBEE', 'FFCDD2', 'EF9A9A', 'E57373', 'EF5350', 'F44336', 'E53935',
    'D32F2F', 'C62828', 'B71C1C',
    // Purples
    'F3E5F5', 'E1BEE7', 'CE93D8', 'BA68C8', 'AB47BC', '9C27B0', '8E24AA',
    '7B1FA2', '6A1B9A', '4A148C',
    // Blues
    'E3F2FD', 'BBDEFB', '90CAF9', '64B5F6', '42A5F5', '2196F3', '1E88E5',
    '1976D2', '1565C0', '0D47A1',
    // Cyans
    'E0F7FA', 'B2EBF2', '80DEEA', '4DD0E1', '26C6DA', '00BCD4', '00ACC1',
    '0097A7', '00838F', '006064',
    // Greens
    'E8F5E9', 'C8E6C9', 'A5D6A7', '81C784', '66BB6A', '4CAF50', '43A047',
    '388E3C', '2E7D32', '1B5E20',
    // Yellows & Oranges
    'FFF3E0', 'FFE0B2', 'FFCC80', 'FFB74D', 'FFA726', 'FF9800', 'FB8C00',
    'F57C00', 'E65100',
    // Grays
    'FAFAFA', 'F5F5F5', 'EEEEEE', 'E0E0E0', 'BDBDBD', '9E9E9E', '757575',
    '616161', '424242', '212121',
  ];

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        // insetPadding: AppSpacing.paddingMd,
        title: label,
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
            ),
            itemCount: predefinedColors.length,
            itemBuilder: (context, index) {
              final colorHex = predefinedColors[index];
              final isSelected =
                  value.replaceAll('#', '').toUpperCase() ==
                  colorHex.toUpperCase();

              return InkWell(
                onTap: () {
                  onChanged(colorHex);
                  Navigator.of(context).pop();
                },
                borderRadius: AppSizing.borderRadiusSm,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorExtensions.fromHex(colorHex),
                    borderRadius: AppSizing.borderRadiusSm,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade300,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: _getContrastColor(colorHex),
                          size: AppSizing.iconLg,
                        )
                      : null,
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Color _getContrastColor(String hexColor) {
    final color = ColorExtensions.fromHex(hexColor);
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showColorPicker(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          prefixIcon: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            width: AppSizing.iconSm,
            height: AppSizing.iconSm,
            decoration: BoxDecoration(
              color: ColorExtensions.fromHex(value),
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
        ),
        child: Text(
          '#${value.replaceAll('#', '').toUpperCase()}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
