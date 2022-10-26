import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:mixyr/state_handlers/audio/audio_player_handler.dart';
import 'package:mixyr/widgets/buttons/expanded_button.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:mixyr/screens/music_screen/music_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:mixyr/config/config.dart';
import 'package:flutter/scheduler.dart';

class Miniplayer extends StatefulWidget {
  final double height;
  final ValueNotifier<double> miniPlayerPercentageNotifier;
  final void Function(double)? onChange;
  const Miniplayer(
      {Key? key,
      this.height = kDefaultIconSize,
      this.onChange,
      required this.miniPlayerPercentageNotifier})
      : super(key: key);

  @override
  State<Miniplayer> createState() => _MiniplayerState();
}

class _MiniplayerState extends State<Miniplayer> with TickerProviderStateMixin {
  Color? color;
  final double iconExtraSize = 7;
  final Velocity scrollVelocity =
      const Velocity(pixelsPerSecond: Offset(20, 0));
  MediaItem? mediaItem;
  Image thumbnailImage = Image.asset(paths[Paths.defaultAlbumArt]!);

  bool isOffstage = false;
  bool showMiniPlayer = false;
  Duration? position;
  double thumbnailSize = 30;
  double margin = 10;
  double padding = 8;
  double progressBarHeight = 1;

  /// When the user drags the miniplayer at this position relative to the screen, the miniplayer values disappear
  double maxVisibilityOfMiniplayer = 0.38;
  double minBottomPaddingOfThumbnail = 0.01;
  double minLeftPaddingOfThumbnail = 0.042;
  double maxBottomPaddingOfThumbnail = 0.2;
  double maxLeftPaddingOfThumbnail = 0.1;
  double minWidthOfThumbnail = 0.084;
  double minHeightOfThumbnail = 0.04;
  double maxThumbnailRelativeMaximumSize = 0.8;

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: isOffstage,
      child: Consumer<AudioHandlerAdmin>(
        builder: (BuildContext context, AudioHandlerAdmin audioHandler,
            Widget? child) {
          return ValueListenableBuilder<bool>(
            valueListenable: audioHandler.getIsMediaInitialised,
            builder:
                (BuildContext context, bool isMediaInitialised, Widget? child) {
              return StreamBuilder<dynamic>(
                stream: audioHandler.getMediaStateStream,
                builder: (context, snapshot) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    setState(() {
                      mediaItem = snapshot.data?.mediaItem;
                      position = snapshot.data?.position;
                    });
                  });
                  if (isMediaInitialised) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      setState(() {
                        showMiniPlayer = true;
                        mediaItem = audioHandler.getMediaItem;
                        // animationController.forward();
                      });
                    });
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                            child: const MusicScreen(),
                            type: PageTransitionType.bottomToTop),
                      ).then((value) {
                        setState(() {
                          isOffstage = false;
                        });
                      });
                      setState(() {
                        isOffstage = true;
                      });
                    },
                    child: AnimatedContainer(
                      duration: kDefaultAnimDuration,
                      padding: EdgeInsets.only(
                          top: isMediaInitialised == false
                              ? relativeHeight(1, context)
                              : relativeHeight(1, context) -
                                  widget.height - // For bottom nav bar
                                  2 *
                                      responsiveHeight(thumbnailSize,
                                          context) - // for thumbnail
                                  4 * padding - // for paddings
                                  -2 *
                                      progressBarHeight), // for bottom progress bar
                      child: Visibility(
                        visible: showMiniPlayer,
                        child: StreamBuilder(
                          stream: audioHandler.getAudioHandler.playbackState
                              .map((state) => state.playing)
                              .distinct(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            return Container(
                              color: Theme.of(context).primaryColor,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(padding),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Hero(
                                          tag: tags[Tags.thumbnailTag]!,
                                          child: SizedBox(
                                            height: responsiveHeight(
                                                thumbnailSize, context),
                                            width: responsiveWidth(
                                                thumbnailSize, context),
                                            child:
                                                audioHandler.getThumbnailImage,
                                          ),
                                        ),
                                        SizedBox(
                                          width: relativeWidth(0.5, context),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextScroll(
                                                mediaItem?.title ?? 'Untitled',
                                                velocity: scrollVelocity,
                                              ),
                                              TextScroll(
                                                mediaItem?.artist ??
                                                    'Unknown artist',
                                                velocity: scrollVelocity,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            ExpandedButton(
                                              extraBackgroundSize:
                                                  iconExtraSize,
                                              onTap: () {},
                                              icon: Icons.skip_previous,
                                            ),
                                            ExpandedButton(
                                              extraBackgroundSize:
                                                  iconExtraSize,
                                              onTap: () {
                                                audioHandler.toggle();
                                              },
                                              icon: snapshot.data ?? false
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                            ),
                                            ExpandedButton(
                                              extraBackgroundSize:
                                                  iconExtraSize,
                                              onTap: () {},
                                              icon: Icons.skip_next,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  LinearProgressIndicator(
                                    value:
                                        (position == null || mediaItem == null
                                            ? 0
                                            : position!.inMilliseconds /
                                                mediaItem!
                                                    .duration!.inMilliseconds),
                                    color: Theme.of(context).focusColor,
                                    minHeight: progressBarHeight,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
