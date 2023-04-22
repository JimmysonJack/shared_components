import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:google_ui/google_ui.dart';

import 'package:shared_component/shared_component.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'loading_environment.dart';
import 'package:get/get.dart';

void main() {
  initApp(
      appName: 'PWA',
      loadEnvFile: () async {
        // debugDisableShadows = true;
        await loadingInvironment(
            devEnvFile: ".env.development", prodEnvFile: ".env.production");
      },
      routes: [
        ChildRoute(
          Modular.initialRoute,
          child: (context, args) => SideNavigation(
            version: '2.0.3',
            
            sideMenuTile: [
              SideMenuTile(
                  title: 'Dashboard', icon: Icons.dashboard, permissions: []),
              SideMenuTile(title: 'Users', icon: Icons.people, permissions: []),
              SideMenuTile(title: 'Facility', icon: Icons.abc, permissions: []),
            ],
          ),
          UserProfileItem(
                        onLogout: () {},
                        email: 'Jimmysonblack@gmail.com',
                        userName: 'Jimmyson Jackson Mnunguri')

                        [
                      MenuItem<String>(
                          title: 'Change Password',
                          icon: Icons.logo_dev,
                          value: 'password'),
                      MenuItem<String>(
                          title: 'Docker',
                          icon: Icons.logo_dev,
                          value: 'docker'),
                    ]
        ),
        // ChildRoute('tiles',
        //     child: (context, args) => TilesSearch(
        //           showGradient: true,
        //           // gradientColors: [Colors.grey, Colors.yellow],
        //           titleColor: Colors.white,

        //           // tileColor: Colors.brown,
        //           tileFields: [
        //             TileFields(
        //                 icon: Icons.login,
        //                 title: 'Logout',
        //                 url: '/login',
        //                 permissions: ['John']),
        //             TileFields(
        //                 icon: Icons.people,
        //                 title: 'User Management',
        //                 url: '/login',
        //                 permissions: ['Mary']),
        //             TileFields(
        //                 icon: Icons.car_crash,
        //                 title: 'Repair',
        //                 url: '/login',
        //                 permissions: ['David', 'Juma']),
        //             TileFields(
        //                 icon: Icons.timer_off,
        //                 title: 'Taiwan',
        //                 url: '/login',
        //                 permissions: ['Mary']),
        //             TileFields(
        //                 icon: Icons.timer_off,
        //                 title: 'Taiwan',
        //                 url: '/login',
        //                 permissions: ['Mary']),
        //             TileFields(
        //                 icon: Icons.timer_off,
        //                 title: 'Taiwan',
        //                 url: '/login',
        //                 permissions: ['Mary']),
        //             TileFields(
        //                 icon: Icons.timer_off,
        //                 title: 'Taiwan',
        //                 url: '/login',
        //                 permissions: ['Mary']),
        //             TileFields(
        //                 icon: Icons.timer_off,
        //                 title: 'Taiwan',
        //                 url: '/login',
        //                 permissions: ['Mary']),
        //             TileFields(
        //                 icon: Icons.timer_off,
        //                 title: 'Taiwan',
        //                 url: '/login',
        //                 permissions: []),
        //             TileFields(
        //                 icon: Icons.timer_off,
        //                 title: 'Taiwan',
        //                 url: '/login',
        //                 permissions: []),
        //             TileFields(
        //                 icon: Icons.timer_off,
        //                 title: 'Taiwan',
        //                 url: '/login',
        //                 permissions: []),
        //             TileFields(
        //                 icon: Icons.timer_off,
        //                 title: 'Taiwan',
        //                 url: '/login',
        //                 permissions: []),
        //           ],
        //         )),

        ChildRoute('/login',
            child: (context, args) => Login(
                  backgroundTheme: BackgroundTheme.techTheme,
                  navigateTo: '',
                ))
      ]);
}

Map<int, Color> colorMap = {
  50: const Color.fromRGBO(147, 205, 72, .1),
  100: const Color.fromRGBO(147, 205, 72, .2),
  200: const Color.fromRGBO(147, 205, 72, .3),
  300: const Color.fromRGBO(147, 205, 72, .4),
  400: const Color.fromRGBO(147, 205, 72, .5),
  500: const Color.fromRGBO(147, 205, 72, .6),
  600: const Color.fromRGBO(147, 205, 72, .7),
  700: const Color.fromRGBO(147, 205, 72, .8),
  800: const Color.fromRGBO(147, 205, 72, .9),
  900: const Color.fromRGBO(147, 205, 72, 1),
};









