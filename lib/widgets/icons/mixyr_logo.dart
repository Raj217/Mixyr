import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mixyr/config/config.dart';

enum LogoType { noTitle, horizontal, vertical }

class MixyrLogo extends StatelessWidget {
  final LogoType logoType;
  final double logoSize;
  final double fontSize;
  final double gap;
  final double letterSpacing;
  const MixyrLogo(
      {Key? key,
      this.logoType = LogoType.horizontal,
      this.logoSize = 17,
      this.fontSize = 17,
      this.gap = 10,
      this.letterSpacing = 7})
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
              _MixyrText(
                fontSize: fontSize,
                letterSpacing: letterSpacing,
              )
            ],
          )
        : logoType == LogoType.vertical
            ? Column(
                children: [
                  _MixyrLogo(
                    logoSize: logoSize,
                  ),
                  SizedBox(height: gap),
                  _MixyrText(
                    fontSize: fontSize,
                    letterSpacing: letterSpacing,
                  )
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
  final double letterSpacing;
  const _MixyrText(
      {Key? key, required this.fontSize, required this.letterSpacing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Mixyr',
      style: TextStyle(
          fontSize: fontSize,
          letterSpacing: letterSpacing,
          fontWeight: FontWeight.w300),
    );
  }
}
