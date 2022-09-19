import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:mixyr/config/paths.dart';
import 'package:mixyr/config/sizes.dart';
import 'package:mixyr/config/utilities.dart';
import 'package:mixyr/state_handlers/audio/audio_player_handler.dart';
import 'package:mixyr/widgets/buttons/expanded_button.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

class Player extends StatefulWidget {
  final Widget child;
  final double height;
  final Widget? appBar;
  final Widget? navBar;
  const Player(
      {Key? key,
      required this.child,
      this.height = kDefaultIconSize,
      this.appBar,
      this.navBar})
      : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> with TickerProviderStateMixin {
  Color? color;
  final double iconExtraSize = 7;
  final Velocity scrollVelocity =
      const Velocity(pixelsPerSecond: Offset(20, 0));
  MediaItem? mediaItem;
  late AnimationController animationController;
  bool showMiniPlayer = false;
  Duration? position;
  double thumbnailSize = 30;
  double margin = 10;

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
  void initState() {
    super.initState();
    getColor();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: widget.height,
    )..addListener(() {
        setState(() {});
      });
  }

  getColor() async {
    Color? c =
        await dominantColor(img: Image.asset(paths[Paths.defaultAlbumArt]!));
    setState(() {
      color = c;
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        widget.child,
        Consumer<AudioHandlerAdmin>(
          builder: (BuildContext context, AudioHandlerAdmin audioHandler,
              Widget? child) {
            return ValueListenableBuilder<bool>(
              valueListenable: audioHandler.getIsMediaInitialised,
              builder: (BuildContext context, bool isMediaInitialised,
                  Widget? child) {
                return StreamBuilder<dynamic>(
                  stream: audioHandler.getMediaStateStream,
                  builder: (context, snapshot) {
                    mediaItem = snapshot.data?.mediaItem;
                    position = snapshot.data?.position;
                    if (isMediaInitialised) {
                      showMiniPlayer = true;
                      mediaItem = audioHandler.getMediaItem;
                      animationController.forward();
                    }
                    return Visibility(
                      visible: showMiniPlayer,
                      child: Padding(
                        padding:
                            EdgeInsets.only(bottom: animationController.value),
                        child: Miniplayer(
                          minHeight: responsiveHeight(
                              thumbnailSize + 2 * margin, context),
                          maxHeight: relativeHeight(1, context),
                          onDismiss: () {},
                          builder: (height, percentage) {
                            double opacity = 1 -
                                (1 / maxVisibilityOfMiniplayer) * percentage;
                            return StreamBuilder(
                              stream: audioHandler.getAudioHandler.playbackState
                                  .map((state) => state.playing)
                                  .distinct(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                return Stack(
                                  children: [
                                    Container(
                                      color: Theme.of(context).primaryColor,
                                      width: relativeWidth(1, context),
                                      height: relativeHeight(1, context),
                                    ),
                                    Container(
                                      height: responsiveHeight(
                                          thumbnailSize + 2 * margin, context),
                                      color: Theme.of(context).primaryColor,
                                      child: Opacity(
                                        opacity: opacity < 0 ? 0 : opacity,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: responsiveHeight(
                                                        thumbnailSize, context),
                                                    width: responsiveWidth(
                                                        thumbnailSize, context),
                                                  ),
                                                  SizedBox(
                                                    width: relativeWidth(
                                                        0.5, context),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        TextScroll(
                                                          mediaItem?.title ??
                                                              'Untitled',
                                                          velocity:
                                                              scrollVelocity,
                                                        ),
                                                        TextScroll(
                                                          mediaItem?.artist ??
                                                              'Unknown artist',
                                                          velocity:
                                                              scrollVelocity,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
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
                                                        icon:
                                                            Icons.skip_previous,
                                                      ),
                                                      ExpandedButton(
                                                        extraBackgroundSize:
                                                            iconExtraSize,
                                                        onTap: () {
                                                          audioHandler.toggle();
                                                        },
                                                        icon: snapshot.data ??
                                                                false
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
                                              value: (position == null ||
                                                      mediaItem == null
                                                  ? 0
                                                  : position!.inMilliseconds /
                                                      mediaItem!.duration!
                                                          .inMilliseconds),
                                              color:
                                                  Theme.of(context).focusColor,
                                              minHeight: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [],
                                    ),
                                    Positioned(
                                      left: relativeLimitedWidthWithMargin(
                                          percentage: percentage,
                                          context: context,
                                          marginPercentage:
                                              minLeftPaddingOfThumbnail,
                                          maxLimitPercentage:
                                              maxLeftPaddingOfThumbnail),
                                      bottom: relativeLimitedHeightWithMargin(
                                          percentage: percentage,
                                          context: context,
                                          maxLimitPercentage:
                                              maxBottomPaddingOfThumbnail,
                                          marginPercentage:
                                              minBottomPaddingOfThumbnail),
                                      child: SizedBox(
                                        height: relativeLimitedHeightWithMargin(
                                            percentage: percentage,
                                            context: context,
                                            marginPercentage:
                                                minHeightOfThumbnail,
                                            maxLimitPercentage:
                                                maxThumbnailRelativeMaximumSize),
                                        width: relativeLimitedWidthWithMargin(
                                            percentage: percentage,
                                            context: context,
                                            marginPercentage:
                                                minWidthOfThumbnail,
                                            maxLimitPercentage:
                                                maxThumbnailRelativeMaximumSize),
                                        child: mediaItem?.artUri?.path != null
                                            ? Image.network(
                                                mediaItem!.artUri!.toString())
                                            : Image.asset(
                                                paths[Paths.defaultAlbumArt]!),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.appBar ?? const SizedBox.expand(),
            widget.navBar ?? const SizedBox.expand()
          ],
        ),
      ],
    );
  }
}
