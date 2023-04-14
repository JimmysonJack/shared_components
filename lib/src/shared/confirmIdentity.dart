// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_ui/google_ui.dart';
// import 'package:flutter_modular/flutter_modular.dart';
import '../../shared_component.dart';

class ConfirmIdentity extends StatelessWidget {
  ConfirmIdentity({Key? key, this.userName, this.userEmail}) : super(key: key);
  final String? userName;
  final String? userEmail;
  final AuthServiceStore authService = AuthServiceStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(builder: (context) {
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
                    controller: TextEditingController(),
                    obscure: true,
                    onChanged: authService.setPass,
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
                    if (authService.loading) IndicateProgress.linear(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: GElevatedButton(
                        'Confirm',
                        onPressed: authService.passwordHasError
                            ? null
                            : authService.loading
                                ? null
                                : () async {
                                    if (await authService.loginUser(context,
                                            username: userEmail!,
                                            password:
                                                authService.passwordValue!) ==
                                        Checking.proceed) {
                                      authService.setLoading(false);
                                      Modular.to.pop();
                                    } else {
                                      authService.setLoading(false);
                                    }
                                  },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                if (!authService.loading)
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: GElevatedButton(
                      'Go To Start Over',
                      color: Theme.of(context).errorColor,
                      onPressed: () {
                        authService.setLoading(true);

                        // Modular.to.navigate('/login/');
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
