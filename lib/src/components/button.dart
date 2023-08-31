import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';

class Button extends StatelessWidget {
  const Button(
      {Key? key,
      this.icon,
      required this.labelText,
      required this.onPressed,
      this.color})
      : super(key: key);
  final String labelText;
  final IconData? icon;
  final Color? color;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: color ?? Theme.of(context).primaryColor),
          icon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Icon(icon,
                color: ThemeController.getInstance().darkMode(
                    darkColor: Colors.white60, lightColor: Colors.black87)),
          ),
          label: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text(labelText, style: Theme.of(context).textTheme.labelLarge),
          ));
    }
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Theme.of(context).primaryColor),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(labelText, style: Theme.of(context).textTheme.labelLarge),
        ));
  }
}
