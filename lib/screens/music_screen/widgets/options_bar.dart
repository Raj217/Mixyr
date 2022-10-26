import 'package:flutter/material.dart';
import 'package:mixyr/config/config.dart';
import 'package:lottie/lottie.dart';

enum IconType { lottie, icon }

class OptionsBar extends StatefulWidget {
  const OptionsBar({Key? key}) : super(key: key);

  @override
  State<OptionsBar> createState() => _OptionsBarState();
}

class _OptionsBarState extends State<OptionsBar> with TickerProviderStateMixin {
  late AnimationController likeAnimationController;
  bool isLiked = false;
  bool isDisliked = false;

  @override
  void initState() {
    super.initState();
    likeAnimationController = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
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
              setState(() {
                isLiked = isLiked == true ? false : true;
                isDisliked = isLiked == true ? false : false;
                if (isLiked == false) {
                  likeAnimationController.animateTo(1).then((value) {
                    likeAnimationController.value = 0;
                    likeAnimationController.stop();
                  });
                } else {
                  likeAnimationController.animateTo(0.59);
                }
              });
            },
          ),
          _icon(
            iconType: IconType.icon,
            icon: isDisliked == true
                ? Icons.thumb_down
                : Icons.thumb_down_alt_outlined,
            onTap: () {
              setState(() {
                isDisliked = isDisliked == true ? false : true;
                isLiked = isDisliked == true ? false : true;
                if (isLiked == false) {
                  likeAnimationController.animateTo(1).then((value) {
                    likeAnimationController.value = 0;
                    likeAnimationController.stop();
                  });
                }
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
