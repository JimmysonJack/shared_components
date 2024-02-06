import 'package:flutter/material.dart';
import 'package:shared_component/src/utils/g_ui/g_text.dart';

import '../../../shared_component.dart';

class UserProfilePopupMenuItem<T> extends PopupMenuItem<T> {
  final UserProfileItem userProfileItem;
  UserProfilePopupMenuItem({super.key, required this.userProfileItem})
      : super(
            enabled: false,
            child: SizedBox(
              // height: 200,
              // width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    backgroundImage: userProfileItem.image != null
                        ? MemoryImage(userProfileItem.image!)
                        : null,
                    child: userProfileItem.image == null
                        ? Center(
                            child: Icon(
                            Icons.person,
                            size: 70,
                            color: ThemeController.getInstance().darkMode(
                                darkColor: Colors.grey.withOpacity(0.5),
                                lightColor: Colors.grey),
                          ))
                        : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 5),
                    child: Text(
                      StorageService.get.user?.name ?? userProfileItem.userName,
                      style: TextStyle(
                        color: ThemeController.getInstance().darkMode(
                            darkColor: Colors.white70,
                            lightColor:
                                Theme.of(NavigationService.get.currentContext!)
                                    .textTheme
                                    .titleLarge!
                                    .color!),
                        fontWeight:
                            Theme.of(NavigationService.get.currentContext!)
                                .textTheme
                                .titleLarge!
                                .fontWeight,
                        fontFamily:
                            Theme.of(NavigationService.get.currentContext!)
                                .textTheme
                                .titleLarge!
                                .fontFamily,
                        fontSize:
                            Theme.of(NavigationService.get.currentContext!)
                                .textTheme
                                .titleLarge!
                                .fontSize,
                        fontStyle:
                            Theme.of(NavigationService.get.currentContext!)
                                .textTheme
                                .titleLarge!
                                .fontStyle,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GText(
                      StorageService.get.user?.email ?? userProfileItem.email,
                      color: ThemeController.getInstance().darkMode(
                          darkColor: Colors.white24,
                          lightColor: Colors.black26),
                      fontSize: Theme.of(NavigationService.get.currentContext!)
                          .textTheme
                          .titleSmall!
                          .fontSize,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: SizeConfig.fullScreen.width,
                      child: Button(
                          labelText: 'Logout',
                          onPressed: () {
                            callOnce = true;
                            userProfileItem.onLogout();
                          }),
                    ),
                  ),
                  const Divider()
                ],
              ),
            ));
}
