import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../shared_component.dart';

class ConfirmIdentity extends StatelessWidget {
  const ConfirmIdentity({Key? key,this.userName,this.userEmail}) : super(key: key);
  final String? userName;
  final String? userEmail;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Observer(
          builder: (context) {
            return Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(userName == null ? 'LOGIN' : 'Confirm Your Identity',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium,),
                ),
                const SizedBox(height: 10,),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(userName ?? '', style: Theme
                        .of(context)
                        .textTheme
                        .titleSmall,),
                    const SizedBox(height: 10,),
                    CustomTextField(
                        hintText: 'Password',
                        controller: TextEditingController(),
                        obscure: true,
                        onChanged: AuthServiceStore
                            .getInstance()
                            .setPass,
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
                        if(AuthServiceStore
                            .getInstance()
                            .loading) IndicateProgress.linear(),
                        SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 4,
                          child: GElevatedButton(
                            'Confirm',
                            onPressed: AuthServiceStore
                                .getInstance()
                                .passwordHasError ? null : AuthServiceStore
                                .getInstance()
                                .loading ? null : () async {
                              if (await AuthServiceStore.getInstance()
                                  .loginUser(username: userEmail!,
                                  password: AuthServiceStore
                                      .getInstance()
                                      .passwordValue!)) {
                                AuthServiceStore.getInstance().setLoading(
                                    false);
                                Modular.to.pop();
                              } else {
                                AuthServiceStore.getInstance().setLoading(
                                    false);
                              }
                            },

                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    if(!AuthServiceStore
                        .getInstance()
                        .loading) SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 4,
                      child: GElevatedButton(
                        'Go To Start Over',
                        color: Theme
                            .of(context)
                            .errorColor,
                        onPressed: () {
                          AuthServiceStore.getInstance().setLoading(true);

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
