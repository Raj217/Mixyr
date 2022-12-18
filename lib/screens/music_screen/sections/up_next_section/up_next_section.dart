import 'package:flutter/material.dart';

class UpNextSection extends StatefulWidget {
  const UpNextSection({Key? key}) : super(key: key);

  @override
  State<UpNextSection> createState() => _UpNextSectionState();
}

class _UpNextSectionState extends State<UpNextSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: SizedBox(),
    );
  }
}
