

class ErrorResponseModel {
  final int? statusCode;
  final String? message;
  final List<ValidationError>? validationErrors;
  final bool? isSuccess;
  final String? utcTimeStamp;
  final dynamic result; // Added result field

  ErrorResponseModel({
    this.statusCode,
    this.message,
    this.validationErrors,
    this.isSuccess,
    this.utcTimeStamp,
    this.result,
  });

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('result') && json['result']?['errors'] != null) {
      // Parse the first type of error response (with validation errors in `result.errors`)
      return ErrorResponseModel(
        statusCode: json['statusCode'],
        message: json['message'],
        validationErrors: (json['result']['errors'] as List)
            .map((e) => ValidationError.fromJson(e))
            .toList(),
        isSuccess: json['isSuccess'],
        utcTimeStamp: json['utcTimeStamp'],
        result: json['result'], // Retain the entire result object
      );
    } else {
      // Parse the second type of error response (without validation errors in `result`)
      return ErrorResponseModel(
        statusCode: json['StatusCode'],
        message: json['Message'],
        isSuccess: json['IsSuccess'],
        utcTimeStamp: json['UtcTimeStamp'],
        result: json['Result'], // Retain the Result field
      );
    }
  }
}

class ValidationError {
  final List<String>? memberNames;
  final String? errorMessage;

  ValidationError({this.memberNames, this.errorMessage});

  factory ValidationError.fromJson(Map<String, dynamic> json) {
    return ValidationError(
      memberNames: List<String>.from(json['memberNames'] ?? []),
      errorMessage: json['errorMessage'],
    );
  }
}