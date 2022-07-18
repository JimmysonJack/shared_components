
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.buttonName,
      required this.onPressed,
      this.fontSize,
      this.radius = true,
      this.elevation,
      this.color,
      this.fontWeight})
      : super(key: key);
  final VoidCallback onPressed;
  final String buttonName;
  final double? elevation;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius ? 5 : 0))),
          backgroundColor: MaterialStateProperty.all(color ?? Theme.of(context).primaryColor),
          elevation:
              MaterialStateProperty.all(elevation == null ? 0 : elevation!),
          minimumSize: MaterialStateProperty.all(const Size(double.infinity, 40)),
        ),
        onPressed: onPressed,
        child: Text(
          buttonName,
          style: TextStyle(
              fontSize: fontSize == null ? 17 : fontSize,
              fontWeight: fontWeight == null ? FontWeight.normal : fontWeight),
        ));
  }
}
