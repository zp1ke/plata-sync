import 'package:flutter/material.dart';
import '../resources/app_icons.dart';
import 'input_decoration.dart';
import '../../utils/datetime.dart';

/// A widget that allows selecting both date and time through separate pickers
class DateTimePickerField extends StatelessWidget {
  final DateTime dateTime;
  final ValueChanged<DateTime> onChanged;
  final String label;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DateTimePickerField({
    required this.dateTime,
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
        final date = await showDatePicker(
          context: context,
          initialDate: dateTime,
          firstDate: firstDate ?? DateTime(2000),
          lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null && context.mounted) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(dateTime),
          );
          if (time != null) {
            final newDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            onChanged(newDateTime);
          }
        }
      },
      child: InputDecorator(
        decoration: inputDecorationWithPrefixIcon(
          labelText: label,
          prefixIcon: AppIcons.calendar,
        ),
        child: Text(dateTime.formatWithTime(), textAlign: TextAlign.center),
      ),
    );
  }
}
