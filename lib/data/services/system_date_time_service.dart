import 'package:flutter/material.dart';
import 'package:macrotrace/domain/services/date_time_service.dart';

class SystemDateTimeService implements DateTimeService {
  @override
  DateTime getToday() {
    return DateUtils.dateOnly(DateTime.now());
  }

  @override
  DateTime getYesterday() {
    return DateUtils.dateOnly(DateTime.now().subtract(const Duration(days: 1)));
  }
}
