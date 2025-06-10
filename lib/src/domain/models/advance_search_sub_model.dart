class AdvanceSearchSubModel {
  List<DataModel>? _industryType;
  List<DataModel>? _skill;
  int? _classifiedType;
  String? _priceFrom;
  String? _priceTo;
  List<DataModel>? _promoCategory;
  List<DataModel>? _propertyType;
  String? _bed;
  String? _bath;
  String? _garage;
  String? _pool;
  String? _petsAllowed;
  String? _landSize;
  String? _landUnitsofMeasure;
  String? _buildingSize;
  String? _buildingUnitsofMeasure;
  int? _costTypeId;
  int? _priceDuration;
  List<DataModel>? _autoType;
  int? _autoSaleType;
  int? _communityType;

  AdvanceSearchSubModel({
    List<DataModel>? industryType,
    List<DataModel>? skill,
    int? classifiedType,
    String? priceFrom,
    String? priceTo,
    List<DataModel>? promoCategory,
    List<DataModel>? propertyType,
    String? bed,
    String? bath,
    String? garage,
    String? pool,
    String? petsAllowed,
    String? landSize,
    String? landUnitsofMeasure,
    String? buildingSize,
    String? buildingUnitsofMeasure,
    int? costTypeId,
    int? priceDuration,
    List<DataModel>? autoType,
    int? autoSaleType,
    int? communityType,
  }) {
    if (industryType != null) {
      _industryType = industryType;
    }
    if (skill != null) {
      _skill = skill;
    }
    if (classifiedType != null) {
      _classifiedType = classifiedType;
    }
    if (priceFrom != null) {
      _priceFrom = priceFrom;
    }
    if (priceTo != null) {
      _priceTo = priceTo;
    }
    if (promoCategory != null) {
      _promoCategory = promoCategory;
    }
    if (propertyType != null) {
      _propertyType = propertyType;
    }
    if (bed != null) {
      _bed = bed;
    }
    if (bath != null) {
      _bath = bath;
    }
    if (garage != null) {
      _garage = garage;
    }
    if (pool != null) {
      _pool = pool;
    }
    if (petsAllowed != null) {
      _petsAllowed = petsAllowed;
    }
    if (landSize != null) {
      _landSize = landSize;
    }
    if (landUnitsofMeasure != null) {
      _landUnitsofMeasure = landUnitsofMeasure;
    }
    if (buildingSize != null) {
      _buildingSize = buildingSize;
    }
    if (buildingUnitsofMeasure != null) {
      _buildingUnitsofMeasure = buildingUnitsofMeasure;
    }
    if (costTypeId != null) {
      _costTypeId = costTypeId;
    }
    if (priceDuration != null) {
      _priceDuration = priceDuration;
    }
    if (autoType != null) {
      _autoType = autoType;
    }
    if (autoSaleType != null) {
      _autoSaleType = autoSaleType;
    }
    if (communityType != null) {
      _communityType = communityType;
    }
  }

  List<DataModel>? get industryType => _industryType;

  set industryType(List<DataModel>? industryType) => _industryType = industryType;

  List<DataModel>? get skill => _skill;

  set skill(List<DataModel>? skill) => _skill = skill;

  int? get classifiedType => _classifiedType;

  set classifiedType(int? classifiedType) => _classifiedType = classifiedType;

  String? get priceFrom => _priceFrom;

  set priceFrom(String? priceFrom) => _priceFrom = priceFrom;

  String? get priceTo => _priceTo;

  set priceTo(String? priceTo) => _priceTo = priceTo;

  List<DataModel>? get promoCategory => _promoCategory;

  set promoCategory(List<DataModel>? promoCategory) => _promoCategory = promoCategory;

  List<DataModel>? get propertyType => _propertyType;

  set propertyType(List<DataModel>? propertyType) => _propertyType = propertyType;

  String? get bed => _bed;

  set bed(String? bed) => _bed = bed;

  String? get bath => _bath;

  set bath(String? bath) => _bath = bath;

  String? get garage => _garage;

  set garage(String? garage) => _garage = garage;

  String? get pool => _pool;

  set pool(String? pool) => _pool = pool;

  String? get petsAllowed => _petsAllowed;

  set petsAllowed(String? petsAllowed) => _petsAllowed = petsAllowed;

  String? get landSize => _landSize;

  set landSize(String? landSize) => _landSize = landSize;

  String? get landUnitsofMeasure => _landUnitsofMeasure;

  set landUnitsofMeasure(String? landUnitsofMeasure) => _landUnitsofMeasure = landUnitsofMeasure;

  String? get buildingSize => _buildingSize;

  set buildingSize(String? buildingSize) => _buildingSize = buildingSize;

  String? get buildingUnitsofMeasure => _buildingUnitsofMeasure;

  set buildingUnitsofMeasure(String? buildingUnitsofMeasure) => _buildingUnitsofMeasure = buildingUnitsofMeasure;

  int? get costTypeId => _costTypeId;

  set costTypeId(int? costTypeId) => _costTypeId = costTypeId;

  int? get priceDuration => _priceDuration;

  set priceDuration(int? priceDuration) => _priceDuration = priceDuration;

  List<DataModel>? get autoType => _autoType;

  set autoType(List<DataModel>? autoType) => _autoType = autoType;

  int? get autoSaleType => _autoSaleType;

  set autoSaleType(int? autoSaleType) => _autoSaleType = autoSaleType;

  int? get communityType => _communityType;

  set communityType(int? communityType) => _communityType = communityType;

  AdvanceSearchSubModel.fromJson(Map<String, dynamic> json) {
    if (json['industryType'] != null) {
      _industryType = <DataModel>[];
      json['industryType'].forEach((v) {
        _industryType!.add(DataModel.fromJson(v));
      });
    }
    if (json['skill'] != null) {
      _skill = <DataModel>[];
      json['skill'].forEach((v) {
        _skill!.add(DataModel.fromJson(v));
      });
    }
    _classifiedType = json['classifiedType'];
    _priceFrom = json['priceFrom'];
    _priceTo = json['priceTo'];
    if (json['promoCategory'] != null) {
      _promoCategory = <DataModel>[];
      json['promoCategory'].forEach((v) {
        _promoCategory!.add(DataModel.fromJson(v));
      });
    }
    if (json['propertyType'] != null) {
      _propertyType = <DataModel>[];
      json['propertyType'].forEach((v) {
        _propertyType!.add(DataModel.fromJson(v));
      });
    }
    _bed = json['bed'];
    _bath = json['bath'];
    _garage = json['garage'];
    _pool = json['pool'];
    _petsAllowed = json['petsAllowed'];
    _landSize = json['landSize'];
    _landUnitsofMeasure = json['landUnitsofMeasure'];
    _buildingSize = json['buildingSize'];
    _buildingUnitsofMeasure = json['buildingUnitsofMeasure'];
    _costTypeId = json['costTypeId'];
    _priceDuration = json['priceDuration'];
    if (json['autoType'] != null) {
      _autoType = <DataModel>[];
      json['autoType'].forEach((v) {
        _autoType!.add(DataModel.fromJson(v));
      });
    }
    _autoSaleType = json['autoSaleType'];
    _communityType = json['communityType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_industryType != null) {
      data['industryType'] = _industryType!.map((v) => v.toJson()).toList();
    }
    if (_skill != null) {
      data['skill'] = _skill!.map((v) => v.toJson()).toList();
    }
    data['classifiedType'] = _classifiedType;
    data['priceFrom'] = _priceFrom;
    data['priceTo'] = _priceTo;
    if (_promoCategory != null) {
      data['promoCategory'] = _promoCategory!.map((v) => v.toJson()).toList();
    }
    if (_propertyType != null) {
      data['propertyType'] = _propertyType!.map((v) => v.toJson()).toList();
    }
    data['bed'] = _bed;
    data['bath'] = _bath;
    data['garage'] = _garage;
    data['pool'] = _pool;
    data['petsAllowed'] = _petsAllowed;
    data['landSize'] = _landSize;
    data['landUnitsofMeasure'] = _landUnitsofMeasure;
    data['buildingSize'] = _buildingSize;
    data['buildingUnitsofMeasure'] = _buildingUnitsofMeasure;
    data['_costTypeId'] = _costTypeId;
    data['priceDuration'] = _priceDuration;
    if (_autoType != null) {
      data['autoType'] = _autoType!.map((v) => v.toJson()).toList();
    }
    data['autoSaleType'] = _autoSaleType;
    data['communityType'] = _communityType;
    return data;
  }
}

class DataModel {
  int? _id;
  String? _name;

  DataModel({int? id, String? name}) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
  }

  int? get id => _id;

  set id(int? id) => _id = id;

  String? get name => _name;

  set name(String? name) => _name = name;

  DataModel.fromJson(Map<String, dynamic> json) {
    _id = json['Id'];
    _name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = _id;
    data['Name'] = _name;
    return data;
  }
}
