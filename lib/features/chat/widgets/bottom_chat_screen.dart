import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/Color.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';

class bottomchatfield extends ConsumerStatefulWidget {
  final String receiveruserid;
  const bottomchatfield({
    required this.receiveruserid,
  });

  @override
  ConsumerState<bottomchatfield> createState() => _bottomchatfieldState();
}

class _bottomchatfieldState extends ConsumerState<bottomchatfield> {
  bool showsendbutton = false;
  final TextEditingController messagecontroller = TextEditingController();

  void sendTextMessage() async {
    if (showsendbutton) {
      ref.read(ChatControllerprovider).sendtextmessage(
            context,
            messagecontroller.text.trim(),
            widget.receiveruserid,
          );
      messagecontroller.text = '';
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    messagecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  showsendbutton = true;
                });
              } else {
                setState(() {
                  showsendbutton = false;
                });
              }
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: mobileChatBoxColor,
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.emoji_emotions,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.gif,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                suffixIcon: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.attach_file,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                hintText: 'Type Message',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                contentPadding: EdgeInsets.all(10)),
            controller: messagecontroller,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8,
            right: 2,
            left: 2,
          ),
          child: CircleAvatar(
            backgroundColor: Color(0xFF128C7E),
            radius: 25,
            child: GestureDetector(
              onTap: sendTextMessage,
              child: Icon(
                showsendbutton ? Icons.send : Icons.mic,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        )
      ],
    );
  }
}
