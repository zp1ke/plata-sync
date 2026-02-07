import 'package:flutter/material.dart';
import '../resources/app_icons.dart';
import 'input_decoration.dart';
import '../../utils/datetime.dart';

/// A widget that allows selecting a date (no time)
class DatePickerField extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  final String label;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DatePickerField({
    required this.date,
    required this.onChanged,
    required this.label,
    this.firstDate,
    this.lastDate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: firstDate ?? DateTime(2000),
          lastDate:
              lastDate ?? DateTime.now().add(const Duration(days: 365 * 10)),
        );
        if (selectedDate != null) {
          // Return the date at midnight
          final newDate = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
          );
          onChanged(newDate);
        }
      },
      child: InputDecorator(
        decoration: inputDecorationWithPrefixIcon(
          labelText: label,
          prefixIcon: AppIcons.calendar,
        ),
        child: Text(date.format(), textAlign: TextAlign.center),
      ),
    );
  }
}
