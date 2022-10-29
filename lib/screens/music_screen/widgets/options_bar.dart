import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:mixyr/config/config.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:mixyr/state_handlers/youtube/youtube_handler.dart';

enum IconType { lottie, icon }

class OptionsBar extends StatefulWidget {
  const OptionsBar({Key? key}) : super(key: key);

  @override
  State<OptionsBar> createState() => _OptionsBarState();
}

class _OptionsBarState extends State<OptionsBar> with TickerProviderStateMixin {
  late AnimationController likeAnimationController;
  String? rating;

  @override
  void initState() {
    super.initState();
    likeAnimationController = AnimationController(vsync: this);
    getRating(Provider.of<YoutubeHandler>(context, listen: false))
        .then((value) => setState(() {
              if (rating == 'like') {
                likeAnimationController.value = 0.59;
              }
            }));
  }

  Future<void> getRating(YoutubeHandler handler) async {
    rating = await handler.getCurrentVideoRating();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<YoutubeHandler>(
        builder: (BuildContext context, YoutubeHandler handler, _) {
      return SizedBox(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: [
            _icon(
              iconType: IconType.lottie,
              lottiePath: paths[Paths.lottieLike]!,
              animationController: likeAnimationController,
              onTap: () async {
                if (rating == 'like') {
                  await handler.setNone();
                } else {
                  await handler.setLiked();
                }
                getRating(handler).then((_) {
                  setState(() {
                    if (rating == 'like') {
                      likeAnimationController.animateTo(0.59);
                    } else {
                      likeAnimationController.value = 0;
                    }
                  });
                });
              },
            ),
            _icon(
              iconType: IconType.icon,
              icon: rating == 'dislike'
                  ? Icons.thumb_down
                  : Icons.thumb_down_alt_outlined,
              onTap: () async {
                if (rating == 'dislike') {
                  await handler.setNone();
                } else {
                  await handler.setDisliked();
                }
                getRating(handler).then((value) {
                  setState(() {
                    if (rating == 'dislike') {
                      likeAnimationController.animateTo(1).then((value) {
                        likeAnimationController.value = 0;
                        likeAnimationController.stop();
                      });
                    }
                  });
                });
              },
            ),
            _icon(
              iconType: IconType.icon,
              icon: Icons.share,
              onTap: () {},
            ),
            _icon(
              iconType: IconType.icon,
              icon: Icons.download,
              onTap: () {},
            ),
            _icon(
              iconType: IconType.icon,
              icon: Icons.playlist_add,
              onTap: () {},
            ),
          ],
        ),
      );
    });
  }
}

class _icon extends StatelessWidget {
  final double height;
  final double width;
  final double gap;
  final IconType iconType;
  final String? lottiePath;
  final AnimationController? animationController;
  final void Function() onTap;
  final IconData? icon;
  const _icon(
      {Key? key,
      this.height = 50,
      this.width = 50,
      this.gap = 10,
      required this.iconType,
      required this.onTap,
      this.lottiePath,
      this.animationController,
      this.icon})
      : assert(
            (iconType == IconType.lottie && lottiePath != null ||
                (iconType == IconType.icon && icon != null)),
            'if iconType is IconType.lottie then lottiePath must be provided, '
            'if iconTYpe is IconType.icon then icon must be provided'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gap),
      child: SizedBox(
        height: height,
        width: width,
        child: iconType == IconType.lottie
            ? GestureDetector(
                onTap: onTap,
                child: Lottie.asset(
                  lottiePath!,
                  controller: animationController,
                  repeat: false,
                  onLoaded: (controller) {
                    animationController!.duration = controller.duration;
                  },
                ),
              )
            : GestureDetector(
                onTap: onTap,
                child: Icon(
                  icon,
                  color: kGreyLight,
                ),
              ),
      ),
    );
  }
}
