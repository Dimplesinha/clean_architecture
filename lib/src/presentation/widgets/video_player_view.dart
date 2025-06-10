import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:workapp/src/core/constants/enum_constant.dart';

/// Stateful widget to fetch and then display video content.
class VideoPlayerView extends StatefulWidget {
  final String filePath;
  final CurrentFileOrigin fileOrigin;
  final bool isFromPlay ;

  const VideoPlayerView({super.key,required this.isFromPlay , required this.filePath, required this.fileOrigin,});

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.fileOrigin == CurrentFileOrigin.network) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.filePath))
        ..initialize().then((_) {
          _controller.play();
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    } else {
      _controller = VideoPlayerController.file(File(widget.filePath))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      floatingActionButton: Visibility(
        visible: widget.isFromPlay,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying ? _controller.pause() : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
