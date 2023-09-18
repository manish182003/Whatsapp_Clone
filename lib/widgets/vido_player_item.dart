import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayeritem extends StatefulWidget {
  final String videourl;
  const VideoPlayeritem({
    Key? key,
    required this.videourl,
  }) : super(key: key);

  @override
  State<VideoPlayeritem> createState() => _VideoPlayeritemState();
}

class _VideoPlayeritemState extends State<VideoPlayeritem> {
  late CachedVideoPlayerController videoPlayerController;
  bool isplay = false;
  @override
  void initState() {
    super.initState();
    videoPlayerController = CachedVideoPlayerController.network(widget.videourl)
      ..initialize().then((value) {
        videoPlayerController.setVolume(1);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(videoPlayerController),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                if (isplay) {
                  videoPlayerController.pause();
                } else {
                  videoPlayerController.play();
                }

                setState(() {
                  isplay = !isplay;
                });
              },
              icon: Icon(
                isplay ? Icons.pause_circle : Icons.play_circle,
                size: 50,
              ),
            ),
          )
        ],
      ),
    );
  }
}
