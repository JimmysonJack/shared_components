import 'package:flutter/material.dart';
import 'package:google_ui/google_ui.dart';

import '../themes/theme.dart';

class CircularProgress extends StatefulWidget {
  const CircularProgress({Key? key}) : super(key: key);

  @override
  State<CircularProgress> createState() => _CircularProgressState();
}

class _CircularProgressState extends State<CircularProgress>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).dividerColor,
            strokeWidth: 1,
            valueColor: animationController.drive(ColorTween(
                begin: Colors.red, end: Theme.of(context).primaryColor))));
  }
}

class LinearProgress extends StatefulWidget {
  const LinearProgress({Key? key}) : super(key: key);

  @override
  State<LinearProgress> createState() => _LinearProgressState();
}

class _LinearProgressState extends State<LinearProgress>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
        backgroundColor: ThemeController.getInstance()
            .darkMode(darkColor: Colors.white12, lightColor: Colors.black12),
        // valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
        valueColor: animationController.drive(ColorTween(
            begin: Colors.red, end: Theme.of(context).primaryColor)));
  }
}

class IndicateProgress {
  static Widget circular() => const Center(child: CircularProgress());

  static Widget linear() => const LinearProgress();

  static Widget cardLinear(String message) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 6,
              ),
              const LinearProgress(),
              const SizedBox(
                height: 3,
              ),
              GText(
                '$message ...',
                fontSize: 11,
              )
            ],
          ),
        ),
      );
}
