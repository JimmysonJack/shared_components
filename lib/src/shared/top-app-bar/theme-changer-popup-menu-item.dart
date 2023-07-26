import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared_component.dart';

class ThemeChangerPopuoMenuItem<T> extends PopupMenuItem<T> {
  final Function() onSettings;
  ThemeChangerPopuoMenuItem({super.key, required this.onSettings})
      : super(
            enabled: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40, top: 20),
                  child: GText(
                    'Theme Changer',
                    color: ThemeController.getInstance().darkMode(
                        darkColor: Colors.white54, lightColor: Colors.black45),
                    fontSize: Theme.of(NavigationService.get.currentContext!)
                        .textTheme
                        .titleLarge!
                        .fontSize,
                  ),
                ),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 110,
                          child: OutlinedButton(
                            onPressed: () {
                              ThemeController.getInstance()
                                  .changeToDarkTheme(true);
                            },
                            style: OutlinedButton.styleFrom(
                                // Set the background color
                                side: BorderSide(
                                    width: 1,
                                    color: ThemeController.getInstance()
                                            .isDarkTheme
                                            .value
                                        ? Colors.white
                                        : Colors.transparent)),
                            child: const GText(
                              'Dark Mode',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 110,
                          child: OutlinedButton(
                            onPressed: () {
                              ThemeController.getInstance()
                                  .changeToDarkTheme(false);
                            },
                            style: OutlinedButton.styleFrom(
                                // Set the background color
                                side: BorderSide(
                                    width: 1,
                                    color: !ThemeController.getInstance()
                                            .isDarkTheme
                                            .value
                                        ? ThemeController.getInstance()
                                            .darkMode(
                                                darkColor: Colors.white,
                                                lightColor: Colors.black)
                                        : Colors.transparent)),
                            child: const GText(
                              'Light Mode',
                            ),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: onSettings,
                  ),
                )
              ],
            ));
}
