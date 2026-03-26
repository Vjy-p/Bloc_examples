import 'package:bloc_examples/utils/colors.dart';
import 'package:bloc_examples/utils/custom_text.dart';
import 'package:flutter/material.dart';

Widget customButton({
  required String text,
  required onTap,
  FontStyle? fontStyle,
  double? fontSize,
  FontWeight? fontWeight,
  Color? textColor,
  Color? buttonColor,
  Widget? icon,
}) {
  return MaterialButton(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(12),
    ),
    color: buttonColor ?? kButtonColor,
    onPressed: onTap,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        customText(
          text: text,
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w400,
          color: textColor ?? kBlackColor,
          fontStyle: fontStyle,
        ),
        ?icon,
      ],
    ),
  );
}
