// ignore_for_file: non_constant_identifier_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';

RegExp regex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

RegExp emailRegExp = RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$');

// ignore: must_be_immutable
class LoginInputs extends StatelessWidget {
  LoginInputs({super.key, required this.navigateTo});
  final String navigateTo;

  final changeController = Get.put(LoginController());

  double height = 0;

  double width = 0;

  final FocusNode username_focusNode = FocusNode();

  final FocusNode password_focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final padding =
        context.layout.value(xs: 20.0, sm: 30, md: 40, lg: 50, xl: 60);
    adjustSize(context);
    return Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          // color: Theme.of(context).cardColor.withOpacity(0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).cardColor.withOpacity(0.3),
              Theme.of(context).cardColor.withOpacity(0.05),
            ],
          ),
        ),

        // padding: const EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: padding.toDouble()),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                      width: 1,
                      color: Theme.of(context).cardColor.withOpacity(0.5))),
              child: Center(
                child: AutofillGroup(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Login',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    color: Theme.of(context).cardColor,
                                    fontSize: 25)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GetX<LoginController>(
                        builder: (_) {
                          return TextFormField(
                            // enableSuggestions: true,
                            // autocorrect: true,
                            autofillHints: const [AutofillHints.email],
                            focusNode: username_focusNode,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,

                            controller: changeController.username,
                            enabled: !_.loading.value,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                            ),
                            // onFieldSubmitted: (value) {
                            //   _focusNode.requestFocus();
                            // },
                            onChanged: (value) {
                              changeController.validateInputs();
                            },
                            validator: (value) {
                              if (isInputNull(value) || value!.isEmpty) {
                                return 'Username must be provided';
                              } else if (!emailRegExp.hasMatch(value)) {
                                return 'Invalid Email Address';
                              }

                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GetX<LoginController>(
                        builder: (_) {
                          return TextFormField(
                            // enableSuggestions: true,
                            // autocorrect: true,
                            autofillHints: const [AutofillHints.password],
                            focusNode: password_focusNode,
                            controller: changeController.password,
                            enabled: !_.loading.value,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _.visibility.value,
                            // obscuringCharacter: '.',
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              suffixIcon: passwordIcon(_.visibility.value),
                              labelText: 'Password',
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                            ),
                            onChanged: (value) {
                              changeController.validateInputs();
                            },
                            validator: (value) {
                              if (isInputNull(value) || value!.isEmpty) {
                                return 'Password can not be empty';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GetX<LoginController>(builder: (controller) {
                        return controller.loading.value
                            ? Container(
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(7)),
                                width: width,
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    LinearProgress(),
                                    GText(
                                      'Authenticating...',
                                      fontSize: 11,
                                    )
                                  ],
                                ),
                              )
                            : ElevatedButton(
                                style: ButtonStyle(
                                    maximumSize:
                                        MaterialStateProperty.all<Size>(
                                            Size(SizeConfig.screenHeight, 60)),
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                            Size(SizeConfig.screenHeight, 50))),
                                onPressed: controller.isButtonEnabled.value
                                    ? () =>
                                        controller.login(context, navigateTo)
                                    : null,
                                child: GText(
                                  'Login',
                                  color: !controller.isButtonEnabled.value
                                      ? ThemeController.getInstance().darkMode(
                                          darkColor: Colors.white60,
                                          lightColor:
                                              !controller.isButtonEnabled.value
                                                  ? Colors.black26
                                                  : Colors.black)
                                      : Theme.of(context).disabledColor,
                                ));
                      })
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget passwordIcon(bool show) {
    return GestureDetector(
      onTapDown: (value) => changeController.changeVisibility(false),
      onTapUp: (value) => changeController.changeVisibility(true),
      child: Icon(show ? Icons.visibility : Icons.visibility_off),
    );
  }

  adjustSize(context) {
    SizeConfig().init(context);
    if (SizeConfig.screenHeight >= 875) {
      height = SizeConfig.screenHeight * 0.4;
      width = SizeConfig.screenHeight * 0.4;
    } else if (SizeConfig.screenHeight < 875 &&
        SizeConfig.screenHeight >= 834) {
      height = SizeConfig.screenHeight * 0.42;
      width = SizeConfig.screenHeight * 0.42;
    } else if (SizeConfig.screenHeight < 834 &&
        SizeConfig.screenHeight >= 797) {
      height = SizeConfig.screenHeight * 0.44;
      width = SizeConfig.screenHeight * 0.44;
    } else if (SizeConfig.screenHeight < 797 &&
        SizeConfig.screenHeight >= 731) {
      height = SizeConfig.screenHeight * 0.48;
      width = SizeConfig.screenHeight * 0.48;
    } else if (SizeConfig.screenHeight < 731) {
      height = SizeConfig.screenHeight * 0.52;
      width = SizeConfig.screenHeight * 0.52;
    }
  }
}

class LoginController extends GetxController {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  final isButtonEnabled = false.obs;
  final visibility = true.obs;
  final loading = false.obs;
  final isFirstLogin = false.obs;
  void validateInputs() {
    isButtonEnabled.value = username.text.isNotEmpty &&
        emailRegExp.hasMatch(username.text) &&
        password.text.isNotEmpty;
  }

  void changeVisibility(bool value) {
    visibility.value = value;
  }

  void login(context, String navigateTo) async {
    loading.value = true;

    Checking state = await SettingsService().login(
        context: context,
        password: password.text,
        userName: username.text,
        navigateTo: navigateTo);
    loading.value = false;
    if (state == Checking.firstLogin || state == Checking.passwordExpired) {
      isFirstLogin.value = true;
    }
  }
}
