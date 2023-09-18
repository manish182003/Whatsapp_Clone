import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:whatsapp_clone/Color.dart';
import 'package:whatsapp_clone/common/Provider/Mesaage_Reply_Provider.dart';
import 'package:whatsapp_clone/common/enum/message_enum.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/widgets/Message_Reply_Preview.dart';

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
  bool isshowwemoji = false;
  FocusNode focusNode = FocusNode();
  bool isrecorderinit = false;
  bool isRecording = false;
  final TextEditingController messagecontroller = TextEditingController();
  FlutterSoundRecorder? soundRecorder;

  @override
  void initState() {
    super.initState();
    soundRecorder = FlutterSoundRecorder();
    openaudio();
  }

  void openaudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic Permission Not Allowed');
    }
    await soundRecorder!.openRecorder();
    isrecorderinit = true;
  }

  void sendTextMessage() async {
    if (showsendbutton) {
      ref.read(ChatControllerprovider).sendtextmessage(
            context,
            messagecontroller.text.trim(),
            widget.receiveruserid,
          );
      messagecontroller.text = '';

      setState(() {});
    } else {
      var dir = await getTemporaryDirectory();
      var path = '${dir.path}/flutter_sound.aac';
      if (!isrecorderinit) {
        return;
      }
      if (isRecording) {
        await soundRecorder!.stopRecorder();
        sendfilemessage(File(path), MessageEnum.audio);
      } else {
        await soundRecorder!.startRecorder(
          toFile: path,
        );
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendfilemessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref.read(ChatControllerprovider).sendfilemessage(
          context,
          file,
          widget.receiveruserid,
          messageEnum,
        );
  }

  void selectimage() async {
    File? image = await PickImageFromGallery(context);
    if (image != null) {
      sendfilemessage(image, MessageEnum.image);
    }
  }

  void selectgif() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      ref.read(ChatControllerprovider).sendGIFMessage(
            context,
            gif.url,
            widget.receiveruserid,
          );
    }
  }

  void selectvideo() async {
    File? video = await PickVideoFromGallery(context);
    if (video != null) {
      sendfilemessage(video, MessageEnum.video);
    }
  }

  void hideEmojiContainer() {
    setState(() {
      isshowwemoji = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isshowwemoji = true;
    });
  }

  void showkeyboard() {
    focusNode.requestFocus();
  }

  void hidekeyboard() {
    focusNode.unfocus();
  }

  void toggleEmojiKeyboardContainer() {
    if (isshowwemoji) {
      showkeyboard();
      hideEmojiContainer();
    } else {
      hidekeyboard();
      showEmojiContainer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    messagecontroller.dispose();
    soundRecorder!.closeRecorder();
    isrecorderinit = false;
  }

  @override
  Widget build(BuildContext context) {
    var messageReply = ref.watch(messageReplyProvider);
    bool isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply ? MessageReplyPreview() : SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                onTap: () {
                  setState(() {
                    isshowwemoji = false;
                  });
                },
                focusNode: focusNode,
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
                              onPressed: () {
                                toggleEmojiKeyboardContainer();
                              },
                              icon: Icon(
                                Icons.emoji_emotions,
                                color: Colors.grey,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                selectgif();
                              },
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
                            onPressed: () {
                              selectimage();
                            },
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              selectvideo();
                            },
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
                        borderSide:
                            BorderSide(width: 0, style: BorderStyle.none)),
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
                  onTap: () {
                    sendTextMessage();
                  },
                  child: Icon(
                    showsendbutton
                        ? Icons.send
                        : isRecording
                            ? Icons.pause
                            : Icons.mic,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
        isshowwemoji
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(
                      () {
                        messagecontroller.text =
                            messagecontroller.text + emoji.emoji;
                      },
                    );
                    if (!showsendbutton) {
                      setState(() {
                        showsendbutton = true;
                      });
                    }
                  },
                ),
              )
            : SizedBox()
      ],
    );
  }
}
