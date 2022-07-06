import 'package:flutter/material.dart';

class CircularProgress extends StatefulWidget {
  const CircularProgress({Key? key}) : super(key: key);

  @override
  State<CircularProgress> createState() => _CircularProgressState();
}

class _CircularProgressState extends State<CircularProgress> {
  late AnimationController animationController;
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   // animationController.dispose();
  // }
  @override
  void initState() {
    super.initState();
    // animationController =
    //     AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    // animationController.repeat();
  }
  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: Center(child: CircularProgressIndicator(
        strokeWidth: 1,
          // valueColor: animationController
          //     .drive(ColorTween(begin: Colors.red, end: Theme.of(context).primaryColor)
          // )
      )),
    );
  }
}

class LinearProgress extends StatefulWidget {
  const LinearProgress({Key? key}) : super(key: key);

  @override
  State<LinearProgress> createState() => _LinearProgressState();
}

class _LinearProgressState extends State<LinearProgress>with TickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // animationController.dispose();
  }
  @override
  void initState() {
    super.initState();
    // animationController =
    //     AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    // animationController.repeat();
  }
  @override
  Widget build(BuildContext context) {
    return const LinearProgressIndicator(
      backgroundColor: Colors.transparent,
    valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
    //     valueColor: animationController
    //         .drive(ColorTween(begin: Colors.red, end: Theme.of(context).primaryColor)
    // )
    );
  }
}

class IndicateProgress{

  static Widget circular() => const Center(child: CircularProgress());

  static Widget linear() => const LinearProgress();
}
