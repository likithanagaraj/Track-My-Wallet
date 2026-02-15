import 'package:flutter/material.dart';

String formatCurrency(double value, {String symbol = '₹', int? decimalDigits}) {
  if (decimalDigits != null) {
    final parts = value.toStringAsFixed(decimalDigits).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    if (decimalDigits == 0) return '$symbol $intPart';
    return '$symbol $intPart.${parts[1]}';
  }

  // If the value is 10,000 or more (5 digits), or if it has no decimals, remove the .00
  if (value >= 10000 || value % 1 == 0) {
    final intPart = value.toInt().toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '$symbol $intPart';
  }
  
  final parts = value.toStringAsFixed(2).split('.');
  final intPart = parts[0].replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );
  return '$symbol $intPart.${parts[1]}';
}
