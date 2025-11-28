import 'package:flutter/material.dart';

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
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(_formatDateTime(context, dateTime)),
      ),
    );
  }

  String _formatDateTime(BuildContext context, DateTime dateTime) {
    final monthNames = {
      1: 'Jan',
      2: 'Feb',
      3: 'Mar',
      4: 'Apr',
      5: 'May',
      6: 'Jun',
      7: 'Jul',
      8: 'Aug',
      9: 'Sep',
      10: 'Oct',
      11: 'Nov',
      12: 'Dec',
    };

    final month = monthNames[dateTime.month] ?? dateTime.month.toString();
    final day = dateTime.day;
    final year = dateTime.year;
    final time = TimeOfDay.fromDateTime(dateTime).format(context);

    return '$month $day, $year $time';
  }
}
