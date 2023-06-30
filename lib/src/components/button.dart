import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  const Button(
      {Key? key, this.icon, required this.labelText, required this.onPressed})
      : super(key: key);
  final String labelText;
  final IconData? icon;
  final void Function()? onPressed;
  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    if (widget.icon != null) {
      return ElevatedButton.icon(
          onPressed: widget.onPressed,
          icon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Icon(widget.icon, color: Colors.white),
          ),
          label: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.labelText,
                style: Theme.of(context).textTheme.labelLarge),
          ));
    }
    return ElevatedButton(
        onPressed: widget.onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.labelText,
              style: Theme.of(context).textTheme.labelLarge),
        ));
  }
}
