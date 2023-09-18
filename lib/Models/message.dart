

import 'package:whatsapp_clone/common/enum/message_enum.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String text;
  final MessageEnum type;
  final DateTime timesent;
  final String messageId;
  final bool isSeen;
  final String repliedMessage;
  final String replyto;
  final MessageEnum repliedMessageType;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.type,
    required this.timesent,
    required this.messageId,
    required this.isSeen,
    required this.repliedMessage,
    required this.replyto,
    required this.repliedMessageType,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'type': type.type,
      'timesent': timesent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
      'repliedMessage': repliedMessage,
      'replyto': replyto,
      'repliedMessageType': repliedMessageType.type,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      type: (map['type'] as String).ToEnum(),
      timesent: DateTime.fromMillisecondsSinceEpoch(map['timesent']),
      messageId: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? false,
      repliedMessage: map['repliedMessage'] ?? '',
      replyto: map['replyto'] ?? '',
      repliedMessageType: (map['repliedMessageType'] as String).ToEnum(),
    );
  }

}
