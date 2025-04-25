import 'package:intl/intl.dart';

String formatCurrency(num value) {
  final formatter = NumberFormat.decimalPattern('en_US');
  return formatter.format(value);
}
