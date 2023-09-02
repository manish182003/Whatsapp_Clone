import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Models/chatcontact.dart';
import 'package:whatsapp_clone/Models/message.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/repository/chat_repository.dart';

final ChatControllerprovider = Provider((ref) {
  final ChatRepository = ref.watch(ChatRepositoryprovider);
  return ChatController(
    chatRepository: ChatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;

  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  void sendtextmessage(
    BuildContext context,
    String text,
    String receiveruserid,
  ) async {
    ref.read(userproviderdata).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverUserid: receiveruserid,
            senderuser: value!,
          ),
        );
  }

  Stream<List<ChatContact>> chatcontacts() {
    return chatRepository.getchatcontacts();
  }

  Stream<List<Message>> chatstream(String receiveruserid) {
    return chatRepository.getchatstream(receiveruserid);
  }
}
