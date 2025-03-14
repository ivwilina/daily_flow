import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final Color primaryColor = const Color(0xFF3F51B5);
final Color whiteTextColor = Color(0xFFFFFFFF);
final Color greyTextColor = Color(0xFF757575);
final Color blackTextColor = Color(0xFF000000);
final Color richBlackColor = Color(0xFF040F0F);
final Color darkSpringGreenColor = Color(0xFF306B34);
final Color carmineColor = Color(0xFF9A031E);


TextStyle get headingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 29,
      fontWeight: FontWeight.bold
    )
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.bold,
      color: greyTextColor
    )
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w400,
      color: blackTextColor
    )
  );
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: greyTextColor
    )
  );
}