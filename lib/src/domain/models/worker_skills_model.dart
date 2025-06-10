class WorkerSkillsModel {
  int? statusCode;
  String? message;
  List<WorkerSkillsResult>? result;
  bool? isSuccess;
  String? utcTimeStamp;

  WorkerSkillsModel({this.statusCode, this.message, this.result, this.isSuccess, this.utcTimeStamp});

  WorkerSkillsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <WorkerSkillsResult>[];
      json['result'].forEach((v) {
        result!.add(WorkerSkillsResult.fromJson(v));
      });
    }
    isSuccess = json['isSuccess'];
    utcTimeStamp = json['utcTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    data['isSuccess'] = isSuccess;
    data['utcTimeStamp'] = utcTimeStamp;
    return data;
  }

  List<String>? get getAllSkills => result?.map((item) => item.skillName as String).toList();
}

class WorkerSkillsResult {
  int? skillId;
  String? skillName;
  String? skillDesc;
  int? displayOrder;
  String? uuid;
  bool? isDeleted;

  WorkerSkillsResult({
    this.skillId,
    this.skillName,
    this.skillDesc,
    this.displayOrder,
    this.uuid,
    this.isDeleted,
  });

  WorkerSkillsResult.fromJson(Map<String, dynamic> json) {
    skillId = json['skillId'];
    skillName = json['skillName'];
    skillDesc = json['skillDesc'];
    displayOrder = json['displayOrder'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skillId'] = skillId;
    data['skillName'] = skillName;
    data['skillDesc'] = skillDesc;
    data['displayOrder'] = displayOrder;
    data['uuid'] = uuid;
    data['isDeleted'] = isDeleted;
    return data;
  }

  @override
  String toString() {
    return 'WorkerSkillsResult{skillId: $skillId, skillName: $skillName, skillDesc: $skillDesc, displayOrder: $displayOrder, uuid: $uuid, isDeleted: $isDeleted}';
  }
}
