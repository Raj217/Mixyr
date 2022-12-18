import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:mixyr/screens/music_screen/sections/up_next_section/up_next_section.dart';
import 'package:mixyr/state_handlers/audio/audio_player_handler.dart';
import 'package:mixyr/widgets/buttons/expanded_button.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'widgets/music_screen_widgets.dart';
import 'package:mixyr/config/config.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final double maxVisibilityOfMiniPlayer = 2;

  /// Whether in song mode or in video mode
  bool isSongMode = true;
  MediaItem? mediaItem;
  Duration? position;
  bool isPlaying = false;
  bool isUpdating = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioHandlerAdmin>(
      builder: (BuildContext context, AudioHandlerAdmin audioHandler, _) {
        return Scaffold(
          body: StreamBuilder(
              stream: audioHandler.getMediaStateStream,
              builder: (context, AsyncSnapshot snapshot) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  position = snapshot.data?.position;
                  mediaItem = snapshot.data?.mediaItem;
                });
                return StreamBuilder(
                  stream: audioHandler.getAudioHandler.playbackState
                      .map((state) => state.playing)
                      .distinct(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    isPlaying = snapshot.data ?? false;
                    return AnimatedContainer(
                      duration: kDefaultAnimDuration,
                      color: audioHandler.getDominantColor != null
                          ? audioHandler.getDominantColor!.withOpacity(0.3)
                          : null,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Transform.rotate(
                                    angle: pi / 2,
                                    child: ExpandedButton(
                                      onTap: () => Navigator.pop(context),
                                      extraBackgroundSize: 60,
                                      icon: Icons.chevron_right,
                                    ),
                                  ),
                                ),
                                ToggleButton(
                                  isSongMode: isSongMode,
                                  onChanged: (bool val) {
                                    setState(() => isSongMode = val);
                                  },
                                  firstText: 'Song',
                                  secondText: 'Video',
                                  firstIcon: Icons.music_note,
                                  secondIcon: Icons.play_arrow,
                                ),
                                ExpandedButton(
                                    icon: Icons.more_vert,
                                    extraBackgroundSize: 60,
                                    onTap: () {})
                              ],
                            ),
                            Hero(
                              tag: tags[Tags.thumbnailTag]!,
                              child: SizedBox(
                                height: relativeHeight(0.3, context),
                                width: relativeWidth(0.853, context),
                                child: audioHandler.getThumbnailImage,
                              ),
                            ),
                            SizedBox(height: responsiveHeight(30, context)),
                            const OptionsBar(),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                child: CustomProgressBar(
                                  audioHandler: audioHandler,
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ExpandedButton(
                                  icon: Icons.skip_previous,
                                  foregroundObjectSize: 50,
                                  onTap: () {
                                    mediaItem = audioHandler.getMediaItem;
                                  },
                                ),
                                StreamBuilder(
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    return ExpandedButton(
                                        icon: isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        backgroundColor:
                                            Theme.of(context).focusColor,
                                        iconColor:
                                            Theme.of(context).primaryColor,
                                        foregroundObjectSize: 50,
                                        onTap: () {
                                          audioHandler.toggle();
                                        });
                                  },
                                ),
                                ExpandedButton(
                                  icon: Icons.skip_next,
                                  foregroundObjectSize: 50,
                                  onTap: () {},
                                ),
                              ],
                            ),
                            UpNextSection(),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
        );
      },
    );
  }
}
