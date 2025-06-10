class ChatResultCommonModel {
  int? messageId;
  int? senderId;
  int? receiverId;
  int? groupId;
  String? messageContent;
  int? mediaTypeId;
  String? mediaUrl;
  String? sentAt;
  int? messageStatusId;
  String? deliveredTime;
  String? readTime;
  int? messageListingId;
  int? messageGroupId;

  ChatResultCommonModel({
    this.messageId,
    this.senderId,
    this.receiverId,
    this.groupId,
    this.messageContent,
    this.mediaTypeId,
    this.mediaUrl,
    this.sentAt,
    this.messageStatusId,
    this.deliveredTime,
    this.readTime,
    this.messageListingId,
    this.messageGroupId,
  });

  ChatResultCommonModel.fromJson(Map<String, dynamic> json) {
    messageId = json['messageId'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    groupId = json['groupId'];
    messageContent = json['messageContent'];
    mediaTypeId = json['mediaTypeId'];
    mediaUrl = json['mediaUrl'];
    sentAt = json['sentAt'];
    messageStatusId = json['messageStatusId'];
    deliveredTime = json['deliveredTime'];
    readTime = json['readTime'];
    messageListingId = json['messageListId'];
    messageGroupId = json['messageGroupId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['messageId'] = messageId;
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['groupId'] = groupId;
    data['messageContent'] = messageContent;
    data['mediaTypeId'] = mediaTypeId;
    data['mediaUrl'] = mediaUrl;
    data['sentAt'] = sentAt;
    data['messageStatusId'] = messageStatusId;
    data['deliveredTime'] = deliveredTime;
    data['readTime'] = readTime;
    data['messageListId'] = messageListingId;
    data['messageGroupId'] = messageGroupId;
    return data;
  }
}