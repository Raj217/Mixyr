import 'package:flutter/material.dart';
import 'package:mixyr/state_handlers/audio/audio_player_handler.dart';
import 'package:mixyr/utils/storage_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mixyr/config/config.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:mixyr/state_handlers/youtube/youtube_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;

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
    getRating(Provider.of<YoutubeHandler>(context, listen: false));
    if (rating == 'like') {
      likeAnimationController.value = 0.59;
    }
  }

  void getRating(YoutubeHandler handler) {
    rating = handler.getCurrentVideoRating();
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
              onTap: () {
                if (rating == 'like') {
                  handler.setNone();
                  rating = 'none';
                } else {
                  handler.setLiked();
                  rating = 'like';
                }
                setState(() {
                  if (rating == 'like') {
                    likeAnimationController.animateTo(0.59);
                  } else {
                    likeAnimationController.value = 0;
                    rating = 'like';
                  }
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
                  handler.setNone();
                  rating = 'none';
                } else {
                  handler.setDisliked();
                  rating = 'dislike';
                }
                setState(() {
                  if (rating == 'dislike') {
                    likeAnimationController.value = 0;
                  }
                });
              },
            ),
            _icon(
              iconType: IconType.icon,
              icon: Icons.share,
              onTap: () {
                String? currentId = handler.getCurrentId;
                if (currentId != null) {
                  Share.share('https://youtu.be/$currentId');
                }
              },
            ),
            _icon(iconType: IconType.icon, icon: Icons.download, onTap: () {}),
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
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.transparent),
        child: iconType == IconType.lottie
            ? InkWell(
                borderRadius: BorderRadius.circular(50),
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
            : InkWell(
                borderRadius: BorderRadius.circular(50),
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
