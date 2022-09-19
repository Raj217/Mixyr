import 'package:flutter/material.dart';
import 'package:mixyr/config/palette.dart';
import 'package:mixyr/config/sizes.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final void Function(String?)? onChanged;
  const CustomTextField(
      {Key? key,
      this.hintText,
      this.keyboardType = TextInputType.text,
      this.controller,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: kWhite,
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: responsiveWidth(12, context)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kGreyLight, width: 2),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: kWhite, width: 2.4),
        ),
      ),
    );
  }
}
