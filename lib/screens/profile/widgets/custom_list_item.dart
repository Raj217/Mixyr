import 'package:flutter/material.dart';
import 'package:mixyr/config/config.dart';

class CustomListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function() onTap;
  const CustomListItem(
      {Key? key, required this.icon, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              color: kWhite,
              size: kDefaultIconSize,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.5,
                  fontSize: kDefaultIconSize - 5),
            )
          ],
        ),
      ),
    );
  }
}
