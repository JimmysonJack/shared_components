import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_component/shared_component.dart';

import 'login_inputs.dart';

RegExp regex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final changeController = Get.put(ChangePasswordController());
  double height = 0;
  double width = 0;
  final FocusNode currentfocusNode = FocusNode();
  final FocusNode newfocusNode = FocusNode();
  final FocusNode verifyfocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    adjustSize(context);
    return Container(
        // height: height,
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                      width: 1,
                      color: Theme.of(context).cardColor.withOpacity(0.5))),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Change Password',
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
                    GetX<ChangePasswordController>(
                      builder: (_) {
                        return TextFormField(
                          focusNode: currentfocusNode,
                          keyboardType: TextInputType.visiblePassword,
                          controller: changeController.currentPassword,
                          textInputAction: TextInputAction.next,
                          enabled: !_.loading.value,
                          obscureText: _.visibility.value,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            suffixIcon: passwordIcon(_.visibility.value, false),
                            labelText: 'Current Password',
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                          ),
                          onChanged: (value) {
                            changeController.validateInputs();
                          },
                          validator: (value) {
                            if (isInputNull(value) || value!.isEmpty) {
                              return 'Old Password must be provided';
                            }

                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GetX<ChangePasswordController>(
                      builder: (_) {
                        return TextFormField(
                          focusNode: newfocusNode,
                          keyboardType: TextInputType.visiblePassword,
                          controller: changeController.newPassword,
                          textInputAction: TextInputAction.next,
                          enabled: !_.loading.value,
                          obscureText: _.newPassVisibility.value,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            suffixIcon:
                                passwordIcon(_.newPassVisibility.value, true),
                            labelText: 'New Password',
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                          ),
                          onChanged: (value) {
                            changeController.validateInputs();
                          },
                          validator: (value) {
                            if (!regex.hasMatch(value!)) {
                              return 'Must Contain Uppercase, Lowercase, Number and Special Character with minimum length of 8';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GetX<ChangePasswordController>(
                      builder: (_) {
                        return TextFormField(
                          focusNode: verifyfocusNode,
                          keyboardType: TextInputType.visiblePassword,
                          controller: changeController.verifyPassword,
                          textInputAction: TextInputAction.next,
                          enabled: !_.loading.value,
                          obscureText: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                          ),
                          onChanged: (value) {
                            changeController.validateInputs();
                          },
                          validator: (value) {
                            if (changeController.newPassword.text != value) {
                              return 'Error! Does not match';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GetX<ChangePasswordController>(builder: (controller) {
                      console('its being called ${controller.isButtonEnabled}');
                      return controller.loading.value
                          ? Container(
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(7)),
                              width: width,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  LinearProgress(),
                                  GText(
                                    'Changing Password...',
                                    fontSize: 11,
                                  )
                                ],
                              ),
                            )
                          : ElevatedButton(
                              style: ButtonStyle(
                                  maximumSize: MaterialStateProperty.all<Size>(
                                      Size(SizeConfig.screenHeight, 60)),
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      Size(SizeConfig.screenHeight, 50))),
                              onPressed: controller.isButtonEnabled.value
                                  ? () => controller.changePassword(context)
                                  : null,
                              child: GText(
                                'Change Password',
                                color: controller.isButtonEnabled.value
                                    ? Theme.of(context).cardColor
                                    : Theme.of(context).disabledColor,
                              ));
                    })
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget passwordIcon(bool show, bool newPass) {
    return GestureDetector(
      onTap: newPass
          ? changeController.changeNewPassVisbility
          : changeController.changeVisibility,
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

class ChangePasswordController extends GetxController {
  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController verifyPassword = TextEditingController();
  final loginController = Get.put(LoginController());

  final isButtonEnabled = false.obs;
  final visibility = true.obs;
  final newPassVisibility = true.obs;
  final loading = false.obs;
  void validateInputs() {
    isButtonEnabled.value = currentPassword.text.isNotEmpty &&
        regex.hasMatch(newPassword.text) &&
        verifyPassword.text == newPassword.text;
  }

  void changeVisibility() {
    visibility.value = !visibility.value;
  }

  void changeNewPassVisbility() {
    newPassVisibility.value = !newPassVisibility.value;
  }

  void changePassword(context) async {
    loading.value = true;

    await Future.delayed(const Duration(seconds: 5), () {
      loginController.isFirstLogin.value = false;
    });

    loading.value = false;
  }
}
