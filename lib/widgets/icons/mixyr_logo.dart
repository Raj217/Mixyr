import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mixyr/config/paths.dart';
import 'package:mixyr/config/sizes.dart';

enum LogoType { noTitle, horizontal, vertical }

class MixyrLogo extends StatelessWidget {
  final LogoType logoType;
  final double logoSize;
  final double fontSize;
  final double gap;
  const MixyrLogo(
      {Key? key,
      this.logoType = LogoType.horizontal,
      this.logoSize = 25,
      this.fontSize = 17,
      this.gap = 10})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return logoType == LogoType.horizontal
        ? Row(
            children: [
              _MixyrLogo(
                logoSize: logoSize,
              ),
              SizedBox(width: gap),
              _MixyrText(fontSize: fontSize)
            ],
          )
        : logoType == LogoType.vertical
            ? Column(
                children: [
                  _MixyrLogo(
                    logoSize: logoSize,
                  ),
                  SizedBox(height: gap),
                  _MixyrText(fontSize: fontSize)
                ],
              )
            : _MixyrLogo(
                logoSize: logoSize,
              );
  }
}

class _MixyrLogo extends StatelessWidget {
  final double logoSize;
  const _MixyrLogo({Key? key, required this.logoSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      paths[Paths.mixyrLogo]!,
      height: responsiveHeight(logoSize, context),
      color: Theme.of(context).focusColor,
    );
  }
}

class _MixyrText extends StatelessWidget {
  final double fontSize;
  const _MixyrText({Key? key, required this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Mixyr',
      style: TextStyle(
          fontSize: fontSize, letterSpacing: 7, fontWeight: FontWeight.w300),
    );
  }
}
