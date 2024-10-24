class NotificationModel {
  final String id;
  final String type;
  final String sender;
  final String receiver;
  final DateTime time;

  NotificationModel({
    required this.id,
    required this.type,
    required this.sender,
    required this.receiver,
    required this.time,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      type: json['type'] ?? "",
      sender: json['sender'] ?? "",
      receiver: json['receiver'] ?? "",
      time: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': sender.compareTo(receiver) < 0
          ? '$sender-$receiver'
          : '$receiver-$sender',
      'type': type,
      'sender': sender,
      'receiver': receiver,
      'time': time.toIso8601String(),
    };
  }
}
