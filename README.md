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
### ListDataTable
- **ListDataTable:** The `ListDataTable` widget is a versatile and configurable table widget in Flutter, designed to display tabular data with various functionalities such as data fetching, CRUD (Create, Read, Update, Delete) operations, and customizable action buttons. It is commonly used to present data in a structured and organized manner.

**Parameters:**

- **fetchPolicy** (optional): Specifies the data fetch policy. It can have one of the following values:

    FetchPolicy.cacheOnly: Fetch data from the cache only.
    FetchPolicy.networkOnly: Fetch data from the network only.
    FetchPolicy.cacheAndNetwork: Try fetching data from the cache first, then from the network.
    FetchPolicy.noCache: Fetch data from the network without caching.
- **progressOnMoreButton** (optional): A boolean value that controls whether to show loading progress in the actionButton when an action is fired.

- **inputs** (optional): A list of OtherParameters objects that represent additional input parameters for the data query. Each OtherParameters object contains keyName, keyValue, and keyType, which are used to specify input parameters for the data query.

- **endPointName**: The name of the endpoint to fetch the data from.

- **queryFields**: A string representing the fields to be fetched from the data endpoint. The fields are specified as a space-separated list.

- **mapFunction**: A callback function that maps the retrieved data to the desired format. It takes an item as input and returns a map with the desired data fields.

- **deleteEndPointName**: The name of the endpoint to use when performing delete operations.

- **deleteUidFieldName** (optional): The name of the field that holds the unique identifier (UID) or ID of the data to be deleted. If not provided, the ListDataTable will use 'uid' as the default field name for UID or ID.

- **actionButtons** (optional): A list of ActionButtonItem objects representing action buttons to be displayed for each row in the table. Each ActionButtonItem contains an icon, a name, and an onPressed callback function.

- **tableAddButton**: A TableAddButton widget representing the add button for creating new data entries. It contains an onPressed callback function and a buttonName representing the button label.

- **topActivityButtons** (optional): A list of TopActivityButton objects representing top activity buttons. These buttons are typically used for primary actions, such as adding new data entries. Each TopActivityButton contains an onTap callback function, a buttonName, and an optional toolTip.

- **headColumns**: A list of HeadTitleItem objects representing the column headers for the table. Each HeadTitleItem contains a titleKey (the key of the data field), and a titleName (the column header name).

**Example Usage:**

```dart  
    ListDataTable(
          fetchPolicy: FetchPolicy.cacheAndNetwork,
      ///this allow showing loading progress in actionButton when action is fired
      progressOnMoreButton: true,
      inputs: [
        OtherParameters(
          keyName: 'userUid',
           keyValue: 'fhfu655785yhg857tghg8ughgu',
            keyType: 'String')
      ],
      endPointName: 'getRoles',
      queryFields: "name description uid",
      /// This is used to map data to desired name
      mapFunction: (item) => {'userName': item['name']},
      deleteEndPointName: 'deleteRole',
      ///You can this field by spacifying your field name which holds id or uid of the desired deleting data, if its not provided [ListDataTable] will user uid as a field name that holds uid or id.
      deleteUidFieldName: 'userUid',
      actionButtons: [
        ActionButtonItem(
            icon: Icons.check_box,
            name: 'Set Permission',
            onPressed: (value) {
              setPermissions(context, value);
            }),
        ActionButtonItem(
            icon: Icons.edit_document,
            name: 'Edit Role',
            onPressed: (value) {
              saveAndUpdateRole(context, value);
            }),
      ],
      tableAddButton: TableAddButton(
          onPressed: () {
            saveAndUpdateRole(context, null);
          },
          buttonName: 'Create Role'),
      topActivityButtons: [
        TopActivityButton(
            onTap: () {
              saveAndUpdateRole(context, null);
            },
            buttonName: 'Create Role',
            // iconData: Icons.create,
            toolTip: 'Adding new Role'),
      ],
      headColumns: [
        HeadTitleItem(
          titleKey: 'name',
          titleName: 'Role Name',
        ),
        HeadTitleItem(
          titleKey: 'description',
          titleName: 'Description',
        ),
      ],
    );
```
### PopupModel Widget
- **PopupModel Widget:** The `PopupModel` widget is a flexible and reusable component in Flutter that allows the display of a popup or dialog to collect user input or show information. It is particularly useful for creating and updating data records with a form-like interface. The widget is highly customizable, supporting dynamic titles, input validation, and data prefilling for update operations.

**Parameters:**

- **buildContext**: The BuildContext used to build the popup widget. It is typically passed as the context parameter.

- **buttonLabel**: A string representing the label for the action button. It can be 'Update' if data is provided (for update operation) or 'Save Role' if data is null (for create operation).

- **checkUnSavedData**: A boolean value indicating whether to check for unsaved data before closing the popup. If true, it may prompt the user to confirm leaving the popup if they have unsaved changes.

- **inputType**: A string representing the input type for the data. It could be used to determine the specific data model or DTO (Data Transfer Object) to use when saving the data.

- **endpointName**: The name of the endpoint to use when saving the data.

- **inputObjectFieldName**: The name of the field that holds the data object to be saved. This field is particularly useful when the input data is wrapped in another object.

- **title**: A string representing the title of the popup. If data is provided, the title will be 'Update Role'; otherwise, it will be 'Create Role'.

- **queryFields**: A string representing the fields to fetch for the data query. In this case, it fetches the 'uid' field.

- **formGroup**: A FormGroup object representing the form structure and data for the popup. The FormGroup contains a list of Group widgets, which group form fields together. Each Group widget may contain one or more form fields, represented by Field.use.input.

**Example Usage:**

```dart 
    PopupModel(
        buildContext: context,
        buttonLabel: data != null ? 'Update' : 'Save Role',
        checkUnSavedData: true,
        inputType: 'SaveRoleDtoInput',
        endpointName: 'saveRole',
        inputObjectFieldName: 'roleDto',
        title: data != null ? 'Update Role' : 'Create Role',
        queryFields: 'uid',
        formGroup: FormGroup(
            updateFields: data,
            group: [
            Group(children: [
                Field.use.input(
                context: context,
                label: 'Role',
                key: 'name',
                validate: true,
                // fieldInputType: FieldInputType
                ),
                Field.use.input(
                context: context,
                label: 'Description',
                key: 'description',
                validate: true,
                // fieldInputType: FieldInputType
                ),
            ])
            ],
        ),
        ).show();

```

**Note:**
The actual functionality of the PopupModel widget may depend on specific implementations and usage in your application. Ensure that you have the required dependencies and data endpoints set up correctly to make the widget work as intended. The form fields inside the FormGroup may also have their own custom validation logic and functionality based on the FieldInputType.


### Field Widget and Form Handling
- **Field Widget and Form Handling:** The `Field` widget is a versatile form handling component in Flutter that enables developers to collect and manage user input efficiently. It offers various input field options, such as text inputs, dropdown menus, date pickers, multi-selects, attachments, checkboxes, and switches. The Field widget supports two main approaches for implementation: the static method approach (`Field.use`) and the instance-based approach (`Field` class instance). Both approaches provide effective form handling capabilities and data management.

#### Static Method Approach (Field.use)

In the static method approach, developers can use the Field.use static method to directly create and implement form fields with various input types.

### Field.use.input

The Field.use.input widget is used for collecting textual data from users, such as names, email addresses, or any other type of text-based information.

**Parameters:**

- **context**: The BuildContext used to build the widget.
- **label**: A string representing the label or description of the input field, providing context or instructions to the user.
- **key**: A unique key to identify and manage the state of the input field.
- **validate**: A boolean value indicating whether to validate the user input.
- **fieldInputType**: A FieldInputType enumeration value specifying the input type. In this case, it is set to FieldInputType.fullName.

**Example**
```dart 
Field.use.input(
    context: context,
    label: 'Role',
    key: 'name',
    validate: true,
    fieldInputType: FieldInputType.fullName
    );
```

### Field.use.select

The Field.use.select widget allows users to choose a single option from a list of items, implemented as a dropdown menu or select input.

**Parameters:**

- **context**: The BuildContext used to build the widget.
- **endPointName**: The name of the endpoint to fetch the data for selectable items.
- **isPageable**: A boolean value indicating whether the data is pageable, allowing loading more items.
- **items**: A list of strings representing the items for the dropdown menu if the data is static.
- **inputType**: The data type of the selected item.
- **widthSize**: An enumeration value from WidthSize specifying the width size of the widget.
- **otherParameters**: A list of OtherParameters objects for additional input parameters in the data query.
- **queryFields**: A string representing the fields to fetch for the data query.
- **readOnly**: A boolean value indicating whether the select input is read-only.
- **label**: A string representing the label or description of the select field.
- **key**: A unique key to identify and manage the state of the select field.
- **validate**: A boolean value indicating whether to validate the user input.
- **fieldInputType**: A FieldInputType enumeration value specifying the input type. In this case, it is set to FieldInputType.other.

**Example**
```dart 
	Field.use.select(
        context: context,
  		endPointName: 'getRoles',
        isPageable: true,
		items:['John', 'Hassan'];
        inputType: 'String',
        widthSize: WidthSize.col12,
        otherParameters: [
            OtherParameters(
                keyName: 'userUid', 
                keyValue: 'ytu5757yey64yeyr67tergy', 
                keyType: 'String')
                ],
        queryFields: 'name uid',
        readOnly: false,
        label: 'Role',
        key: 'name',
        validate: true,
        fieldInputType: FieldInputType.other
              );
```

### Field.use.date

The Field.use.date widget provides a date picker input for selecting dates.

**Parameters:**

- **context**: The BuildContext used to build the widget.
- **inputType**: The data type of the selected date.
- **widthSize**: An enumeration value from WidthSize specifying the width size of the widget.
- **disableFuture**: A boolean value indicating whether future dates are disabled.
- **disablePast**: A boolean value indicating whether past dates are disabled.
- **disable**: A boolean value indicating whether the date input is disabled.
- **isDateRange**: A boolean value indicating whether the input is for selecting a date range.
- **onSelectedDate**: A callback function called when a date is selected.
- **queryFields**: A string representing the fields to fetch for the data query.
- **label**: A string representing the label or description of the date field.
- **key**: A unique key to identify and manage the state of the date field.
- **validate**: A boolean value indicating whether to validate the user input.
- **fieldInputType**: A FieldInputType enumeration value specifying the input type. In this case, it is set to FieldInputType.date.

**Example**

```dart 
Field.use.date(
    context: context,
    inputType: 'String',
    widthSize: WidthSize.col12,
	disableFuture: true,
    disablePast: false,
    disable: false,
    isDateRange: false,
    onSelectedDate: (value) {
      
    },
    queryFields: 'name uid',
    label: 'Starting Date',
    key: 'startingDate',
    validate: true,
    fieldInputType: FieldInputType.date
    );
```

### Field.use.multiSelect

The Field.use.multiSelect widget allows users to select multiple options from a list of items.


**Parameters:**

- **context**: The BuildContext used to build the widget.
- **endPointName**: The name of the endpoint to fetch the data for selectable items.
- **isPageable**: A boolean value indicating whether the data is pageable, allowing loading more items.
- **items**: A list of strings representing the items for the dropdown menu if the data is static.
- **inputType**: The data type of the selected item.
- **widthSize**: An enumeration value from WidthSize specifying the width size of the widget.
- **otherParameters**: A list of OtherParameters objects for additional input parameters in the data query.
- **queryFields**: A string representing the fields to fetch for the data query.
- **readOnly**: A boolean value indicating whether the select input is read-only.
- **label**: A string representing the label or description of the select field.
- **key**: A unique key to identify and manage the state of the select field.
- **validate**: A boolean value indicating whether to validate the user input.
- **fieldInputType**: A FieldInputType enumeration value specifying the input type. In this case, it is set to FieldInputType.other.

**Example**
```dart 
	Field.use.multiSelect(
        context: context,
  		endPointName: 'getRoles',
        isPageable: true,
		items:['John', 'Hassan'];
        inputType: 'String',
        widthSize: WidthSize.col12,
        otherParameters: [
            OtherParameters(
                keyName: 'userUid', 
                keyValue: 'ytu5757yey64yeyr67tergy', 
                keyType: 'String')
                ],
        queryFields: 'name uid',
        readOnly: false,
        label: 'Role',
        key: 'name',
        validate: true,
        fieldInputType: FieldInputType.other
              );
```

### Field.use.checkbox

The Field.use.checkbox widget allows users to select or toggle a boolean value using a checkbox input.

**Parameters:**

- **context**: The BuildContext used to build the widget.
- **label**: A string representing the label or description of the checkbox field, providing context or instructions to the user.
- **key**: A unique key to identify and manage the state of the checkbox field.
- **validate**: A boolean value indicating whether to validate the user input.
- **fieldInputType**: A FieldInputType enumeration value specifying the input type. In this case, it is set to FieldInputType.other.

**Example**
```dart 
    Field.use.checkbox(
        context: context,
        label: 'Role',
        key: 'name',
        validate: true,
        fieldInputType: FieldInputType.other
        );
```

### Field.use.attachment

The Field.use.attachment widget is used to collect attachments or files from the user.

**Parameters:**

- **context**: The BuildContext used to build the widget.
- **label**: A string representing the label or description of the attachment field, providing context or instructions to the user.
- **key**: A unique key to identify and manage the state of the attachment field.
- **validate**: A boolean value indicating whether to validate the user input.
- **fieldInputType**: A FieldInputType enumeration value specifying the input type. In this case, it is set to FieldInputType.other.

**Example**
```dart 
Field.use.attachment(
    context: context,
    label: 'Role',
    key: 'name',
    validate: true,
    fieldInputType: FieldInputType.other
    );
```


### Field.use.switch

The Field.use.switch widget allows users to toggle a boolean value using a switch input.

**Parameters:**

- **context**: The BuildContext used to build the widget.
- **label**: A string representing the label or description of the switch field, providing context or instructions to the user.
- **key**: A unique key to identify and manage the state of the switch field.
- **validate**: A boolean value indicating whether to validate the user input.
- **fieldInputType**: A FieldInputType enumeration value specifying the input type. In this case, it is set to FieldInputType.other.

**Example**

```dart 
Field.use.switch(
    context: context,
    label: 'Role',
    key: 'name',
    validate: true,
    fieldInputType: FieldInputType.other
        );
```

#### Instance-based Approach (Field Class Instance)

The instance-based approach involves creating an instance of the `Field` class, `fieldController`, which provides more control and flexibility over form handling.

Using `fieldController`, developers can create and manage form fields using methods like `fieldController.field.input()`, and also implement listeners to receive form data changes using `fieldController.fieldUpdates.listen((data) {})`.

### Recommendation

It is recommended to use the instance-based approach, creating a Field class instance whenever input fields need to be implemented. This allows for better data management and responsiveness to form changes. Additionally, when using `PopupModel`, all `FieldValues.getInstance().instanceValues` and `fieldController.fieldUpdates` will be notified of changes, ensuring accurate data updates when sending data to the backend.

**Note:** Ensure that the required dependencies and data endpoints are correctly set up to make the widgets work as intended. The form fields inside the `FormGroup` may have their custom validation logic and functionality based on the `FieldInputType`.

### PageableDataTable

- **PageableDataTable:** The `PageableDataTable` is a custom Flutter widget designed to display tabular data with features for querying data from an API endpoint, deleting data through a separate delete endpoint, implementing a search mechanism, and providing various action buttons for user interactions. Below is the documentation for the `PageableDataTable` widget:

**Widget Description:**

`PageableDataTable` is a versatile widget that provides a user-friendly and responsive way to display tabular data in a Flutter app. It offers several customizable options for querying data, managing data deletions, and defining user actions through action buttons.

**Widget Properties:**

- **endPointName** (required String): The API endpoint name from which to query the initial data for the table.

- **queryFields** (required String): A space-separated list of field names to request from the API during data querying.

- **mapFunction** (required Function): A mapping function that transforms the fetched data to desired column names for display. It takes an item as input and returns a Map<String, dynamic> representing the transformed data.

- **deleteEndPointName** (required String): The API endpoint name for deleting data. When a delete action is triggered on a row, the widget will use this endpoint to delete the corresponding data.

- **deleteUidFieldName** (String, optional): The field name that holds the unique identifier (UID) or ID of the data to be deleted. If not provided, the widget will use 'uid' as the default field name to locate the data for deletion.

- **actionButtons** (List<ActionButtonItem>, optional): A list of action buttons displayed on each row of the table. Each button is represented by an ActionButtonItem, which includes an icon, name, and an onPressed callback function.

- **tableAddButton** (TableAddButton, optional): A button displayed at the top of the table for adding new data. It includes an onPressed callback and a button name.

- **topActivityButtons** (List<TopActivityButton>, optional): Additional activity buttons displayed at the top of the table. Each button is represented by a TopActivityButton, which includes an onTap callback, button name, and optional tooltip.

- **headColumns** (List<HeadTitleItem>, optional): Defines the column headers of the table. Each HeadTitleItem includes a titleKey (corresponding to the key in the mapFunction result) and a titleName to display as the column header.

**Example Usage:**

```dart 
        PageableDataTable(
              ///this will be provided only if the provided endpoint has some paramater to take
      otherParameters: [
        OtherParameters(
          keyName: 'userUid',
           keyValue: 'fhfu655785yhg857tghg8ughgu',
            keyType: 'String')
      ],
      endPointName: 'getRoles',
      queryFields: "name description uid",
      /// This is used to map data to desired name
      mapFunction: (item) => {'userName': item['name']},
      deleteEndPointName: 'deleteRole',
      ///You can this field by spacifying your field name which holds id or uid of the desired deleting data, if its not provided [PageableDataTable] will user uid as a field name that holds uid or id.
      deleteUidFieldName: 'userUid',
      actionButtons: [
        ActionButtonItem(
            icon: Icons.check_box,
            name: 'Set Permission',
            onPressed: (value) {
              setPermissions(context, value);
            }),
        ActionButtonItem(
            icon: Icons.edit_document,
            name: 'Edit Role',
            onPressed: (value) {
              saveAndUpdateRole(context, value);
            }),
      ],
      tableAddButton: TableAddButton(
          onPressed: () {
            saveAndUpdateRole(context, null);
          },
          buttonName: 'Create Role'),
      topActivityButtons: [
        TopActivityButton(
            onTap: () {
              saveAndUpdateRole(context, null);
            },
            buttonName: 'Create Role',
            // iconData: Icons.create,
            toolTip: 'Adding new Role'),
      ],
      headColumns: [
        HeadTitleItem(
          titleKey: 'name',
          titleName: 'Role Name',
        ),
        HeadTitleItem(
          titleKey: 'description',
          titleName: 'Description',
        ),
      ],
    );
```

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

**Configuration Staps**
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

