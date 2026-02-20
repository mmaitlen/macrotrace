import 'package:flutter/material.dart';
import 'package:macrotrace/domain/services/date_time_service.dart';

/// A concrete implementation of [DateTimeService] that provides system-level
/// date and time information.
///
/// This service is designed to be testable by allowing a "now" function to be
/// injected. This prevents tests from being coupled to the system's current
/// DateTime.now(), which can lead to flaky tests or make it difficult to
/// test specific date-sensitive scenarios (e.g., "today", "yesterday").
///
/// By injecting `getNow`, tests can provide a fixed or simulated DateTime,
/// making the service's behavior predictable and isolated.
class SystemDateTimeService implements DateTimeService {
  final DateTime Function() _getNow;

  /// Constructs a [SystemDateTimeService].
  ///
  /// [getNow] is an optional function that, when provided, will be used to
  /// determine the "current" DateTime. If not provided, [DateTime.now] is
  /// used by default, reflecting the actual system time.
  SystemDateTimeService({DateTime Function()? getNow})
    : _getNow = getNow ?? DateTime.now;

  @override
  DateTime getToday() {
    return DateUtils.dateOnly(_getNow());
  }

  @override
  DateTime getYesterday() {
    return DateUtils.dateOnly(_getNow().subtract(const Duration(days: 1)));
  }
}
