import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Models/chatcontact.dart';
import 'package:whatsapp_clone/Models/message.dart';
import 'package:whatsapp_clone/common/Provider/Mesaage_Reply_Provider.dart';
import 'package:whatsapp_clone/common/enum/message_enum.dart';
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
    final messagereply = ref.read(messageReplyProvider);
    ref.read(userproviderdata).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverUserid: receiveruserid,
            senderuser: value!,
            messageReply: messagereply,
          ),
        );
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  Stream<List<ChatContact>> chatcontacts() {
    return chatRepository.getchatcontacts();
  }

  Stream<List<Message>> chatstream(String receiveruserid) {
    return chatRepository.getchatstream(receiveruserid);
  }

  void sendfilemessage(
    BuildContext context,
    File file,
    String receiveruserid,
    MessageEnum messageEnum,
  ) async {
    final messagereply = ref.read(messageReplyProvider);
    ref.read(userproviderdata).whenData(
          (value) => chatRepository.sendfileMessgae(
              context: context,
              file: file,
              ref: ref,
              messageEnum: messageEnum,
              receiveruserid: receiveruserid,
              senderuserdata: value!,
              messageReply: messagereply),
        );
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendGIFMessage(
      BuildContext context, String gifurl, String receiveruserid) {
    int gifurlpartindex = gifurl.lastIndexOf('-') + 1;
    String gif = gifurl.substring(gifurlpartindex);
    String newgifurl = 'https://i.giphy.com/media/$gif/200.gif';

    final messagereply = ref.read(messageReplyProvider);
    ref.read(userproviderdata).whenData(
          (value) => chatRepository.sendGIFMessage(
            context: context,
            gifurl: newgifurl,
            receiverUserid: receiveruserid,
            senderuser: value!,
            messageReply: messagereply,
          ),
        );
    ref.read(messageReplyProvider.state).update((state) => null);
  }
}
