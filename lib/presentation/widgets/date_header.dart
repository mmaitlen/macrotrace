import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateHeader extends StatelessWidget {
  final DateTime date;
  final Map<String, double> summary;

  const DateHeader({
    super.key,
    required this.date,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    String getFormattedDate() {
      final now = DateTime.now();
      final today = DateUtils.dateOnly(now);
      final yesterday = today.subtract(const Duration(days: 1));

      if (DateUtils.isSameDay(date, today)) {
        return 'Today';
      } else if (DateUtils.isSameDay(date, yesterday)) {
        return 'Yesterday';
      } else {
        return DateFormat.yMMMMd().format(date);
      }
    }

    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            getFormattedDate(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            'P: ${summary['protein']?.toStringAsFixed(1) ?? 0} C: ${summary['carbohydrate']?.toStringAsFixed(1) ?? 0} F: ${summary['fat']?.toStringAsFixed(1) ?? 0}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
