import 'package:flutter/material.dart';

class DateHeader extends StatelessWidget {
  final String formattedDate;
  final String formattedSummary;

  const DateHeader({
    super.key,
    required this.formattedDate,
    required this.formattedSummary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 139, 197, 239),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(formattedDate, style: Theme.of(context).textTheme.titleMedium),
          Text(formattedSummary, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
