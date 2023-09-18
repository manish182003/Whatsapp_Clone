import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/Color.dart';
import 'package:whatsapp_clone/common/Provider/Mesaage_Reply_Provider.dart';
import 'package:whatsapp_clone/widgets/display_text_image_gif.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagereply = ref.watch(messageReplyProvider);
    return Container(
      decoration: BoxDecoration(
          color: messageColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          )),
      width: 350,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messagereply!.isMe ? 'Me' : 'Opposite',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  cancelReply(ref);
                },
                child: Icon(
                  Icons.close,
                  size: 16,
                ),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          DisplayMessage(
            message: messagereply.Message,
            type: messagereply.messageEnum,
          )
        ],
      ),
    );
  }
}
