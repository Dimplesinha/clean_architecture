import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DecimalInputFormatter extends TextInputFormatter {
  final int maxDigitsBeforeDecimal;
  final int maxDigitsAfterDecimal;

  DecimalInputFormatter({
    required this.maxDigitsBeforeDecimal,
    required this.maxDigitsAfterDecimal,
  });

  @override
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(',', '');

    if (newText.isNotEmpty && !RegExp(r'^\d*\.?\d*$').hasMatch(newText)) {
      return oldValue;
    }

    final parts = newText.split('.');
    final beforeDecimal = parts[0];
    final afterDecimal = parts.length > 1 ? parts[1] : '';

    if (beforeDecimal.length > maxDigitsBeforeDecimal) {
      return oldValue;
    }

    if (afterDecimal.length > maxDigitsAfterDecimal) {
      return oldValue;
    }

    final formattedBeforeDecimal = beforeDecimal.isEmpty
        ? ''
        : NumberFormat('#,###').format(int.parse(beforeDecimal));

    final newFormattedText = parts.length > 1
        ? '$formattedBeforeDecimal.$afterDecimal'
        : formattedBeforeDecimal;

    // Calculate cursor position based on change in number of commas
    int numCommasBefore = _countCommas(oldValue.text);
    int numCommasAfter = _countCommas(newFormattedText);
    int commaDelta = numCommasAfter - numCommasBefore;

    int newOffset = newValue.selection.end + commaDelta;
    newOffset = newOffset.clamp(0, newFormattedText.length);

    return TextEditingValue(
      text: newFormattedText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }

  int _countCommas(String text) => ','.allMatches(text).length;

}
