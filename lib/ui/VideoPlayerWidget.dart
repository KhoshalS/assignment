import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  final CachedVideoPlayerController controller;
  final bool isVisible;

  const VideoPlayerWidget({
    Key? key,
    required this.controller,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isVisible) {
      controller.play();
    } else {
      controller.pause();
    }
    return GestureDetector(
        onTap: () {
          // Toggle between play and pause on tap
          if (controller.value.isPlaying) {
            controller.pause();
          } else {
            controller.play();
          }
        },
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CachedVideoPlayer(controller), // The video player
          // child: CachedVideoPlayer(controller),
        ));
  }
}

