import 'dart:convert';

class AdvanceSearchItemMetaData {
  final int controlId;
  final String? value;
  final String? controlLabel;
  final String? controlName;
  final String? displayValue;

  AdvanceSearchItemMetaData({
    required this.controlId,
    required this.value,
    required this.controlLabel,
    required this.controlName,
    required this.displayValue,
  });

  // Convert JSON to Dart Object
  factory AdvanceSearchItemMetaData.fromJson(Map<String, dynamic> json) {
    return AdvanceSearchItemMetaData(
      controlId: json['controlId'],
      value: json['value'],
      controlLabel: json['controlLabel'],
      controlName: json['controlName'],
      displayValue: json['displayValue'],
    );
  }

  // Convert Dart Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'controlId': controlId,
      'value': value,
      'controlLabel': controlLabel,
      'controlName': controlName,
      'displayValue': displayValue,
    };
  }
}

void main() {
  // JSON String
  String jsonString = '''
  {
    "controlId": 1557,
    "value": "3",
    "controlLabel": "Auto Type",
    "controlName": "autoType",
    "displayValue": "Bus"
  }
  ''';

  // Convert JSON string to Dart Object
  Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  AdvanceSearchItemMetaData item = AdvanceSearchItemMetaData.fromJson(jsonMap);

  // Print Dart object
  print('Dart Object: ${item.controlLabel}, ${item.displayValue}');

  // Convert Dart Object back to JSON
  String encodedJson = jsonEncode(item.toJson());
  print('JSON: $encodedJson');
}
