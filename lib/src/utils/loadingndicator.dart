import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(strokeWidth: 1,)),
    );
  }
}

class ProgressIndicator{

  static Widget circular() => const Center(child: CircularProgressIndicator(strokeWidth: 1,));

  static Widget linear() => const LinearProgressIndicator();
}
