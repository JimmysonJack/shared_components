<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->


# Shared_Component

Shared_Component is a comprehensive collection of reusable components, classes, and methods designed to accelerate Flutter app development. It provides a set of powerful tools and functionalities that aim to streamline common tasks and enhance the user experience.

## Features

- **Table:** A flexible and customizable table widget for displaying tabular data with sorting, filtering, and pagination capabilities.
- **Dialog with Input Forms:** Easily create dialogs with input forms to collect user data or prompt for specific information.
- **Custom TextField:** A customized version of the TextField widget with additional features such as input validation, formatting, and masks.
- **Dropdown Search and Multiple Select Dropdown Search:** Dropdown widgets with search functionality and the ability to select single or multiple options.
- **Pageable Table:** An advanced table widget that supports server-side pagination for handling large datasets efficiently.
- **GraphQL Query and Mutation Methods:** Simplify communication with GraphQL APIs by providing convenient methods for executing queries and mutations.
- **Side Nav and Top App Bar:** Pre-built navigation components for creating responsive and user-friendly app layouts.
- **User Dashboard:** Ready-to-use dashboard components to help you build informative and visually appealing user interfaces.
- **Date Picker:** A date selection widget with customizable styling and options.
- **Attachment Input:** An input field for uploading and managing file attachments.
- **Checkbox and Switch:** Enhanced versions of the default Flutter widgets with additional features and customizability.
- **SettingsService:** A set of reusable methods for managing app settings and preferences.

## Installation

To install `Shared_Component` package, follow the steps below:
1. Download Shared_Component from git Repository and then place it any whare you want. We are only doing it because its not yet published.
2. Add the package to your Flutter project's `pubspec.yaml` file, in the path put an address where you placed Shared_component package.

```yaml
 dependencies:
    Shared_Component:
        path: "<<PACKAGE_ADDRESS>>/shared_component"
```

3. Run the `flutter pub get` command to fetch the package and its dependencies.
4. Import the necessary components and start leveraging the powerful functionalities offered by the Package Name.

## Getting Started

**Configuration Stapes**
- By using `Shared_Component` package you dont have to call a `runAp()` to initialize your App, its already taken care of. What you have to do is to call a `initApp()` fuction inside the `main()`, and it will handle the rest.
-  `Shared_Component` is using `flutter_module` to manage routing and manage module architecture in the project. Its also using `GetX` for dependence injection and state management.

    ```dart
    void main() async{
        ///This line ensures that Flutter is properly initialized before running the app
         WidgetsFlutterBinding.ensureInitialized();

         ///initializes the app with some configuration
        initApp(
            appName: 'Shared Components',
            loadEnvFile: () async {

                ///Loading Inviroment files from the root of the project
                await loadingInvironment(
                    devEnvFile: ".env.development", prodEnvFile: ".env.production");
            },
            routes: [
                ChildRoute('/landing',
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
                                    title: 'Profile',
                                    icon: Icons.details,
                                    value: 'profile'),
                            ],
                            onTap: (value) {},
                            userProfileDetails: UserProfileItem(
                                onLogout: () {
                                    SettingsService.use
                                        .logout(Modular.initialRoute, context);
                                },
                                email: 'Jimmysonblack@gmail.com',
                                userName: 'Jimmyson Jackson Mnunguri')),
                        sideMenuTile: [
                            SideMenuTile(
                                title: 'Dashboard',
                                icon: Icons.dashboard,
                                permissions: ['ACCESS_BILLS']),
                            SideMenuTile(
                                title: 'Users',
                                icon: Icons.people,
                                permissions: ['ACCESS_ROLE', 'ACCESS']),
                            SideMenuTile(
                                title: 'Facility', icon: Icons.abc, permissions: []),
                        ],
                        body: const UserManager(),
                        ),
                    guards: [AuthGuard()]),

                ChildRoute('/login',
                    child: (context, args) => Login(
                        navigateTo: 'landing',
                        backgroundTheme: BackgroundTheme.techTheme)),

                RedirectRoute(Modular.initialRoute, to: 'login')
            ]);

    }
    ```

    ```dart
        import 'package:flutter/foundation.dart';
        import 'package:shared_component/shared_component.dart';

        loadingInvironment(
            {required String devEnvFile, required String prodEnvFile}) async {
        String fileName = kReleaseMode ? prodEnvFile : devEnvFile;
        await dotenv.load(fileName: fileName);
        Environment.getInstance().setClientId(dotenv.env['CLIENT_ID']!);
        Environment.getInstance().setClientSecret(dotenv.env['CLIENT_SECRET']!);
        Environment.getInstance().setServerUrl(dotenv.env['SERVER_URL']!);
        }
    ```
    Thsis Method loads Production invernment when the app is running on production inveronment, and it will load the dev inveronment if the in development invronment

- **Note:** Avoid using `Get.context` to get `context` globally, instead use NavigationService.
```dart
    NavigationService.navigatorKey.currentContext!
```
    This will enable you to get current `context` globally.

## Documentation Structure

The Package Name documentation is organized as follows:
- API Reference: Detailed documentation of each component, class, and method offered by the package.
- Examples and Use Cases: Real-world examples and use cases to illustrate how to utilize the package effectively.
- Configuration and Customization: Instructions on how to customize the package's components to fit your specific requirements.
- Troubleshooting: Solutions to common issues and errors that developers may encounter while using the package.
- Support and Contact: Information on how to seek support or get in touch with the package maintainer.

We hope that the Package Name package proves to be a valuable asset for your Flutter app development journey. Enjoy the convenience, flexibility, and time-saving capabilities it brings to your projects!

