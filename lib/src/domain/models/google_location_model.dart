class LocationPredictionModel {
  final List<PlacePrediction>? predictions;
  final String? status;

  LocationPredictionModel({
    this.predictions,
    this.status,
  });

  // fromJson method
  factory LocationPredictionModel.fromJson(Map<String, dynamic> json) {
    return LocationPredictionModel(
      predictions: (json['predictions'] as List<dynamic>?)?.map((e) => PlacePrediction.fromJson(e as Map<String, dynamic>)).toList(),
      status: json['status'] as String?,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'predictions': predictions?.map((e) => e.toJson()).toList(),
      'status': status,
    };
  }
}

class PlacePrediction {
  final String? description;
  final List<MatchedSubstring>? matchedSubstrings;
  final String? placeId;
  final String? reference;
  final StructuredFormatting? structuredFormatting;
  final List<Term>? terms;
  final List<String>? types;

  PlacePrediction({
    this.description,
    this.matchedSubstrings,
    this.placeId,
    this.reference,
    this.structuredFormatting,
    this.terms,
    this.types,
  });

  // fromJson method
  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      description: json['description'] as String?,
      matchedSubstrings: (json['matched_substrings'] as List<dynamic>?)?.map((e) => MatchedSubstring.fromJson(e as Map<String, dynamic>)).toList(),
      placeId: json['place_id'] as String?,
      reference: json['reference'] as String?,
      structuredFormatting: json['structured_formatting'] != null ? StructuredFormatting.fromJson(json['structured_formatting'] as Map<String, dynamic>) : null,
      terms: (json['terms'] as List<dynamic>?)?.map((e) => Term.fromJson(e as Map<String, dynamic>)).toList(),
      types: (json['types'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'matched_substrings': matchedSubstrings?.map((e) => e.toJson()).toList(),
      'place_id': placeId,
      'reference': reference,
      'structured_formatting': structuredFormatting?.toJson(),
      'terms': terms?.map((e) => e.toJson()).toList(),
      'types': types,
    };
  }
}

class MatchedSubstring {
  final int? length;
  final int? offset;

  MatchedSubstring({
    this.length,
    this.offset,
  });

  // fromJson method
  factory MatchedSubstring.fromJson(Map<String, dynamic> json) {
    return MatchedSubstring(
      length: json['length'] as int?,
      offset: json['offset'] as int?,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'offset': offset,
    };
  }
}

class StructuredFormatting {
  final String? mainText;
  final List<MatchedSubstring>? mainTextMatchedSubstrings;
  final String? secondaryText;

  StructuredFormatting({
    this.mainText,
    this.mainTextMatchedSubstrings,
    this.secondaryText,
  });

  // fromJson method
  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'] as String?,
      mainTextMatchedSubstrings: (json['main_text_matched_substrings'] as List<dynamic>?)?.map((e) => MatchedSubstring.fromJson(e as Map<String, dynamic>)).toList(),
      secondaryText: json['secondary_text'] as String?,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'main_text': mainText,
      'main_text_matched_substrings': mainTextMatchedSubstrings?.map((e) => e.toJson()).toList(),
      'secondary_text': secondaryText,
    };
  }
}

class Term {
  final int? offset;
  final String? value;

  Term({
    this.offset,
    this.value,
  });

  // fromJson method
  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      offset: json['offset'] as int?,
      value: json['value'] as String?,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'value': value,
    };
  }
}

class PredictionsResponse {
  final List<LocationPredictionModel>? predictions;
  final String? status;

  PredictionsResponse({
    this.predictions,
    this.status,
  });

  // fromJson method
  factory PredictionsResponse.fromJson(Map<String, dynamic> json) {
    return PredictionsResponse(
      predictions: (json['predictions'] as List<dynamic>?)?.map((e) => LocationPredictionModel.fromJson(e as Map<String, dynamic>)).toList(),
      status: json['status'] as String?,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'predictions': predictions?.map((e) => e.toJson()).toList(),
      'status': status,
    };
  }
}

class AddressComponents {
  String? longName;
  String? shortName;
  List<String>? types;

  AddressComponents({this.longName, this.shortName, this.types});

  AddressComponents.fromJson(Map<String, dynamic> json) {
    longName = json['long_name'];
    shortName = json['short_name'];
    types = json['types'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['long_name'] = longName;
    data['short_name'] = shortName;
    data['types'] = types;
    return data;
  }
}
