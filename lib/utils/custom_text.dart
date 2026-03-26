import 'package:bloc_examples/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customText({
  required String text,
  Color? color,
  FontWeight? fontWeight,
  double? fontSize,
  FontStyle? fontStyle,
  TextAlign? textAlign,
  int? maxLines,
}) {
  return Text(
    text,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: maxLines != null ? TextOverflow.ellipsis : null,
    style: customTextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
    ),
  );
}

TextStyle customTextStyle({
  Color? color,
  FontWeight? fontWeight,
  double? fontSize,
  FontStyle? fontStyle,
}) {
  return GoogleFonts.ubuntu(
    color: color ?? kTextColor,
    fontSize: fontSize ?? 14,
    fontWeight: fontWeight ?? FontWeight.normal,
    fontStyle: fontStyle,
  );
}
