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
            appBarPosition: AppBarPosition.side,
            version: '2.0.3',
            topAppBarDetails: TopAppBarDetails(
                title: 'Top Bar',
                menuItems: [
                  MenuItem<String>(
                      title: 'Change Password',
                      icon: Icons.logo_dev,
                      value: 'password'),
                  MenuItem<String>(
                      title: 'Profile', icon: Icons.details, value: 'profile'),
                ],
                onTap: (value) {},
                userProfileDetails: UserProfileItem(
                    onLogout: () {},
                    email: 'Jimmysonblack@gmail.com',
                    userName: 'Jimmyson Jackson Mnunguri')),
            sideMenuTile: [
              SideMenuTile(
                  title: 'Dashboard',
                  icon: Icons.dashboard,
                  permissions: ['ACCESS_USER']),
              SideMenuTile(
                  title: 'Users',
                  icon: Icons.people,
                  permissions: ['ACCESS_ROLE', 'ACCESS']),
              SideMenuTile(title: 'Facility', icon: Icons.abc, permissions: []),
            ],
            body: const UsersWidget(),
          ),
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

class UsersWidget extends StatelessWidget {
  const UsersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const PermissionSettings(
      endPointName: 'savePermissions',
      titleKey: 'titleKey',
    );

    // ListDataTable(
    //   endPointName: 'getUsers',
    //   queryFields: "name uid",
    //   mapFunction: (item) => {'userName': item['name']},
    //   deleteEndPointName: 'deleteUser',
    //   deleteUidFieldName: 'userUid',
    //   actionButtons: [
    //     ActionButtonItem(
    //         icon: Icons.perm_data_setting_sharp,
    //         name: 'Set Permission',
    //         onPressed: (value) {
    //           RebuildToRefetch.instance().refetch();
    //           console(value);
    //         })
    //   ],
    //   tableAddButton:
    //       TableAddButton(onPressed: () {}, buttonName: 'Create User'),
    //   topActivityButtons: [
    //     TopActivityButton(
    //         onTap: () {},
    //         // buttonName: 'Create User',
    //         iconData: Icons.create,
    //         toolTip: 'For creating user'),
    //     TopActivityButton(
    //         onTap: () {},
    //         buttonName: 'Create User',
    //         // iconData: Icons.create,
    //         toolTip: 'For creating user'),
    //     TopActivityButton(
    //         onTap: () {},
    //         buttonName: 'Create Role',
    //         // iconData: Icons.create,
    //         toolTip: 'For creating user'),
    //   ],
    //   headColumns: [
    //     HeadTitleItem(
    //       titleKey: 'userName',
    //       titleName: 'User Name',
    //     ),
    //     HeadTitleItem(
    //         titleKey: 'uid',
    //         titleName: 'Key',
    //         alignment: Alignment.centerRight),
    //   ],
    // );
  }
}


    // const ExpansionTileCard(
    //   initialElevation: 1,
    //   title: Text('Card title'),
    //   subtitle: Text('Subtitle'),
    //   leading: Icon(Icons.data_thresholding_sharp),
    //   children: [
    //     Divider(
    //       height: 1,
    //       thickness: 1,
    //     ),
    //     ListTile(
    //       title: Text('Title'),
    //       subtitle: Text('Subtitle'),
    //     ),
    //     ListTile(
    //       title: Text('Title1'),
    //       subtitle: Text('Subtitle1'),
    //     ),
    //     ListTile(
    //       title: Text('Title2'),
    //       subtitle: Text('Subtitle2'),
    //     ),
    //   ],
    // );


