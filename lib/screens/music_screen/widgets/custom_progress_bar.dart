import 'package:flutter/material.dart';
import 'package:mixyr/state_handlers/audio/audio_player_handler.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class CustomProgressBar extends StatefulWidget {
  AudioHandlerAdmin audioHandler;
  void Function(ThumbDragDetails)? onUpdate;
  void Function()? onUpdateEnd;
  CustomProgressBar(
      {Key? key, required this.audioHandler, this.onUpdate, this.onUpdateEnd})
      : super(key: key);

  @override
  State<CustomProgressBar> createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar> {
  bool isUpdating = false;
  Duration? updatingPosition;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.audioHandler.positionStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ProgressBar(
              progress: updatingPosition ?? snapshot.data ?? Duration.zero,
              thumbRadius: 8,
              thumbGlowRadius: 20,
              total: widget.audioHandler.getAudioTotalDuration ?? Duration.zero,
              onDragUpdate: (ThumbDragDetails thumbDragDetails) {
                setState(() {
                  updatingPosition = thumbDragDetails.timeStamp;
                });
              },
              onDragEnd: () {
                setState(() {
                  if (updatingPosition != null) {
                    widget.audioHandler.getAudioHandler.seek(updatingPosition!);
                    updatingPosition = null;
                  }
                });
              });
        });
  }
}
