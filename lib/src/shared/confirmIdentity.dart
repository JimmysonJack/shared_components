// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:google_ui/google_ui.dart';
// import 'package:flutter_modular/flutter_modular.dart';
import '../../shared_component.dart';

class ConfirmIdentity extends StatelessWidget {
  ConfirmIdentity({Key? key, this.userName, this.userEmail}) : super(key: key);
  final String? userName;
  final String? userEmail;
  final authService = Get.put(AuthServiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<AuthServiceController>(builder: (_) {
        return Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                userName == null ? 'LOGIN' : 'Confirm Your Identity',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userName ?? '',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    hintText: 'Password',
                    controller: _.password,
                    obscure: true,
                    onChanged: _.verifyPassword,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password must be provided';
                      }
                      return null;
                    })
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_.loading.value) IndicateProgress.linear(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: GElevatedButton(
                        'Confirm',
                        onPressed: _.isButtonEnabled.value
                            ? null
                            : _.loading.value
                                ? null
                                : () async {
                                    _.loading.value = true;
                                    if (await authService.loginUser(context,
                                            username: userEmail!,
                                            password:
                                                authService.password.text) ==
                                        Checking.proceed) {
                                      Modular.to.pop();
                                    }
                                    _.loading.value = false;
                                  },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                if (!_.loading.value)
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: GElevatedButton(
                      'Go To Start Over',
                      color: Theme.of(context).colorScheme.error,
                      onPressed: () {
                        // _.loading.value = true;
                        Modular.to.navigate('/login');
                      },
                    ),
                  ),
              ],
            )
          ],
        );
      }),
    );
  }
}
