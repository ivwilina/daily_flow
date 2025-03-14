// import 'package:dailyflow_prototype_2/ui/themes.dart';
import 'package:dailyflow_prototype_2/ui/themes.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  const MyButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 120,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13.0),
          color: primaryColor
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
    );
  }
}