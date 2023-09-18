import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enum/message_enum.dart';

class MessageReply {
  final String Message;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReply(this.Message, this.isMe, this.messageEnum);
}

final messageReplyProvider = StateProvider<MessageReply?>((ref) => null);
