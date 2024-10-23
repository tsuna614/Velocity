class MessageModel {
  final String conversationId;
  final String message;
  final String sender;
  final String receiver;
  final DateTime time;

  MessageModel({
    required this.conversationId,
    required this.message,
    required this.sender,
    required this.receiver,
    required this.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      conversationId: json['conversationId'],
      message: json['message'] ?? "",
      sender: json['sender'] ?? "",
      receiver: json['receiver'] ?? "",
      time: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversationId': sender.compareTo(receiver) < 0
          ? '$sender-$receiver'
          : '$receiver-$sender',
      'message': message,
      'sender': sender,
      'receiver': receiver,
      'time': time.toIso8601String(),
    };
  }
}
