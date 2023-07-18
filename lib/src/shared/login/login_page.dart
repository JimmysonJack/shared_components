import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'background.dart';
import 'change_password.dart';
import 'conditional.dart';
import 'login_inputs.dart';

class Login extends StatelessWidget {
  final String navigateTo;
  final BackgroundTheme backgroundTheme;
  Login({super.key, required this.navigateTo, required this.backgroundTheme});

  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(182, 18, 84, 135),
        body: Container(
          decoration: BoxDecoration(
            gradient: linearGradient,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Background(
            backgroudTheme: backgroundTheme,
            child: GetX<LoginController>(
              builder: (_) {
                return Conditional(
                    condition: _.isFirstLogin.value,
                    altinateChild: ChangePassword(),
                    child: LoginInputs(
                      navigateTo: navigateTo,
                    ));
              },
            ),
          ),
        ));
  }
}

LinearGradient linearGradient = const LinearGradient(
  colors: [
    Color.fromRGBO(244, 255, 131, 1),
    Color.fromRGBO(255, 230, 131, 1),
    Color.fromRGBO(255, 195, 131, 1),
    Color.fromRGBO(255, 160, 131, 1),
    Color.fromRGBO(255, 125, 131, 1),
    Color.fromRGBO(255, 100, 131, 1),
    Color.fromRGBO(255, 85, 131, 1),
    Color.fromRGBO(255, 75, 131, 1),
    Color.fromRGBO(255, 70, 131, 1),
    Color.fromRGBO(255, 67, 131, 1),
    Color.fromRGBO(255, 65, 131, 1),
    Color.fromRGBO(255, 63, 131, 1),
    Color.fromRGBO(255, 61, 131, 1),
    Color.fromRGBO(255, 59, 131, 1),
    Color.fromRGBO(255, 57, 131, 1),
    Color.fromRGBO(255, 55, 131, 1),
  ],
  // stops: [
  //   0.5,
  //   0.10,
  //   0.15,
  //   0.20,
  // ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

RadialGradient radialGradient = const RadialGradient(
  center: Alignment.center,
  // radius: 0.9,
  colors: [
    Color(0xFF405DE6),
    Color(0xFF5851DB),
    Color(0xFF833AB4),
    Color(0xFFC13584),
    Color(0xFFF77737),
    Color(0xFFFC4A1A),
  ],
  stops: [
    0.0,
    0.17,
    0.34,
    0.51,
    0.68,
    0.85,
  ],
);

SweepGradient sweepGradient = const SweepGradient(
  colors: [
    Color(0xFF405DE6),
    Color(0xFF5851DB),
    Color(0xFF833AB4),
    Color(0xFFC13584),
    Color(0xFFF77737),
    Color(0xFFFC4A1A),
  ],
  stops: [
    0.0,
    0.2,
    0.4,
    0.6,
    0.8,
    0.10,
  ],
);
