import 'package:intl/intl.dart';

String formatCurrency(num value) {
  final formatter = NumberFormat.decimalPattern('en_US');
  return formatter.format(value);
}

String formatCurrencyShort(num value) {
  if (value >= 1_000_000_000) {
    return '${(value / 1_000_000_000).toStringAsFixed(1)}t đ';
  } else if (value >= 1_000_000) {
    return '${(value / 1_000_000).toStringAsFixed(1)}tr đ';
  } else if (value >= 1_000) {
    return '${(value / 1_000).toStringAsFixed(1)}k đ';
  } else {
    return value.toString();
  }
}