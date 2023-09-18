import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/Models/message.dart';
import 'package:whatsapp_clone/common/Provider/Mesaage_Reply_Provider.dart';
import 'package:whatsapp_clone/common/enum/message_enum.dart';
import 'package:whatsapp_clone/common/widget/loader.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/widgets/mymessagecard.dart';
import 'package:whatsapp_clone/widgets/sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiveruserid;
  const ChatList({
    required this.receiveruserid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messagecontroller = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messagecontroller.dispose();
  }

  onMessageswipe(
    String Message,
    bool isMe,
    MessageEnum messageEnum,
  ) {
    ref.read(messageReplyProvider.state).update(
          (state) => MessageReply(
            Message,
            isMe,
            messageEnum,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream:
            ref.read(ChatControllerprovider).chatstream(widget.receiveruserid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loader();
          }
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            messagecontroller
                .jumpTo(messagecontroller.position.maxScrollExtent);
          });
          return ListView.builder(
            controller: messagecontroller,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messagedata = snapshot.data![index];
              var timesent = DateFormat.Hm().format(messagedata.timesent);
              if (messagedata.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messagedata.text,
                  date: timesent,
                  type: messagedata.type,
                  repliedtext: messagedata.repliedMessage,
                  username: messagedata.replyto,
                  repliedMessageType: messagedata.repliedMessageType,
                  onLeftSwipe: () {
                    onMessageswipe(messagedata.text, true, messagedata.type);
                  },
                );
              }
              return SenderMessageCard(
                message: messagedata.text,
                date: timesent,
                type: messagedata.type,
                repliedtext: messagedata.repliedMessage,
                username: messagedata.replyto,
                repliedMessageType: messagedata.repliedMessageType,
                onRightSwipe: () {
                  onMessageswipe(
                    messagedata.text,
                    false,
                    messagedata.type,
                  );
                },
              );
            },
          );
        });
  }
}
