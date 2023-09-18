import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';

import 'package:whatsapp_clone/common/enum/message_enum.dart';
import 'package:whatsapp_clone/widgets/vido_player_item.dart';

class DisplayMessage extends StatelessWidget {
  final String message;
  final MessageEnum type;

  const DisplayMessage({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isplaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return type == MessageEnum.text
        ? Text(
            message,
            style: TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.video
            ? VideoPlayeritem(videourl: message)
            : type == MessageEnum.gif
                ? CachedNetworkImage(
                    imageUrl: message,
                  )
                : type == MessageEnum.audio
                    ? StatefulBuilder(builder: (context, setstate) {
                        return IconButton(
                          constraints: BoxConstraints(
                            minWidth: 100,
                          ),
                          onPressed: () async {
                            if (isplaying) {
                              audioPlayer.pause();
                              setstate(() {
                                isplaying = false;
                              });
                            } else {
                              await audioPlayer.play(UrlSource(message));
                      
                              setstate(() {
                                isplaying = true;
                              });
                            }
                          },
                          icon: Icon(
                            isplaying ? Icons.pause_circle : Icons.play_circle,
                          ),
                        );
                      })
                    : ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: message,
                        ),
                      );
  }
}
