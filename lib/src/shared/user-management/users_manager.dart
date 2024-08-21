import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';
import 'package:shared_component/src/shared/user-management/details_card.dart';
import 'package:shared_component/src/shared/user-management/user-roles-controller.dart';

import 'helper-classes.dart';
import 'dashboard/user_dashboard.dart';
import 'user_list_widget.dart';

class UserManager extends StatefulWidget {
  const UserManager(
      {super.key, required this.roleConfig, required this.userConfig});
  final RoleConfig roleConfig;
  final UserConfig userConfig;

  @override
  State<UserManager> createState() => _UserManagerState();
}

class _UserManagerState extends State<UserManager>
    with SingleTickerProviderStateMixin {
  double width = 0;
  double height = SizeConfig.fullScreen.height;
  bool showDetails = false;
  bool shakeIt = false;
  Map<String, dynamic> userData = {};
  bool locked = true;
  bool active = true;
  bool credentialCanExpire = true;
  bool credentialExpired = true;
  FieldController fieldController = FieldController();
  Map<String, dynamic>? fieldData;
  UserRolesController userRolesController = UserRolesController();

  @override
  void initState() {
    width = 0;

    // width = SizeConfig.fullScreen.width * 0.5;
    // _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool mobileSize = MediaQuery.of(context).size.width < 700;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!(mobileSize && width != 0))
          Flexible(
              child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 1000),
            crossFadeState: !showDetails
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: UserListWidget(
              userRolesController: userRolesController,
              getRolesByUserEndpoint: widget.userConfig.getRolesByUserEndpoint,
              getRolesByUserResponseFields:
                  widget.userConfig.getRolesByUserResponseFields,
              responseFields: widget.userConfig.getUserResponseFields,
              endpointName: widget.userConfig.getUsersEndpoint,
              onCreateUser: () {
                userRolesController.userListData.clear();
                userRolesController.disableAllFields.value = false;
                // userDetailsController.updateField([]);
                createAndUpdateUser(
                    endpointName: widget.userConfig.saveUserEndpoint);
              },
              onTap: (Map<String, dynamic> data) {
                // fieldController = FieldController();
                setState(() {
                  // showDetails = !showDetails;
                  shakeIt = true;

                  if (!showDetails) {
                    width = 0;
                  } else {
                    width = mobileSize
                        ? SizeConfig.fullScreen.width
                        : SizeConfig.fullScreen.width * 0.5;
                  }
                });
                Future.delayed(const Duration(milliseconds: 200), () {
                  setState(() {
                    shakeIt = false;
                    userData = data;
                    locked = !userData['accountNonLocked'];
                    active = !userData['enabled'];
                    credentialCanExpire =
                        userData['passwordCanExpire'] ?? false;
                    credentialExpired = !userData['credentialsNonExpired'];
                    fieldController.field.fieldValuesController.clearInstance();
                  });
                });
              },
              onExit: () {
                setState(() {
                  showDetails = false;
                  if (!showDetails) {
                    width = 0;
                  } else {
                    width = SizeConfig.fullScreen.width * 0.5;
                  }
                });
              },
            ),
            secondChild: SizedBox(
              height: height,
              // color: Colors.blueGrey,
              child: Dashboard(
                onUsersPressed: () {
                  setState(() {
                    showDetails = true;
                  });
                },
                onRolesPressed: () {
                  PopDialog.showWidget(
                      title: 'Roles',
                      context: context,
                      child: RoleWidget(
                        roleConfig: widget.roleConfig,
                      ));
                },
              ),
            ),
          )),
        DetailCard(
          userRolesController: userRolesController,
          fieldController: fieldController,
          assignRoleToUserEndpoint: widget.userConfig.assignRoleToUserEndpoint,
          getRolesByUserEndpoint: widget.userConfig.getRolesByUserEndpoint,
          getRolesByUserResponseFields:
              widget.userConfig.getRolesByUserResponseFields,
          getUserEndpointName: widget.userConfig.getUsersEndpoint,
          getUserResponseFields: widget.userConfig.getUserResponseFields,
          updateUserEndpoint: widget.userConfig.saveUserEndpoint,
          onCloseDetailes: () {
            setState(() {
              width = 0;
            });
          },
          user: userData,
          onDeleteUser: () {
            setState(() {
              width = 0;
            });
          },
          loggedInUserDetails: LoggedInUserDetails(
            lastLogin: userData['lastLogin'],
            authenticatedDevice: null,
            lastLoginLocation: null,
            loggedInDevice: null,
          ),
          userDetails: UserDetails(
              passwordCanExpire: credentialCanExpire,
              email: userData['email'],
              fullName: userData['name'],
              onDisabled: (value) {},
              onLocked: (value) {},
              onPasswordCanExpire: (value) {},
              phone: userData['phoneNumber'],
              region: userData['facility']?['name'],
              disabled: active,
              passwordExpired: credentialExpired,
              isLoked: locked),
          userUid: userData['uid'] ?? '',
          height: height,
          width: width,
          showDetails: showDetails,
          shakeIt: shakeIt,
          onEditUser: (data) {
            createAndUpdateUser(
                endpointName: widget.userConfig.saveUserEndpoint,
                updatingData: data);
          },
        )
      ],
    );
  }

  onPressDashboard(bool mobileSize) {
    setState(() {
      showDetails = !showDetails;
      if (!showDetails) {
        width = 0;
      } else {
        width = mobileSize
            ? SizeConfig.fullScreen.width
            : SizeConfig.fullScreen.width * 0.5;
      }
    });
  }

  createAndUpdateUser(
      {Map<String, dynamic>? updatingData, required String endpointName}) {
    FieldController userDetailsController = FieldController();
    userDetailsController.fieldUpdates.listen((event) {
      fieldData = SettingsService.use.convertListOfMapToMap(event['data']);
    });
    int currentIndex = -1;
    if (updatingData != null) {
      updatingData['facilityUids'] =
          List<Map<String, dynamic>>.from(updatingData['facilities']);
      final names = updatingData['name'].toString().split(' ');
      userRolesController.userListData.value = [
        {
          'firstName': names[0],
          'middleName': names[1],
          'lastName': names[2],
          'inputType': names[2].runtimeType.toString()
        }
      ];
      currentIndex = 0;
      userRolesController.disableAllFields.value = true;
    }

    PopupModel(
        fieldController: fieldController,
        buttonLabel: updatingData == null ? 'Create User' : 'Update User',
        title: updatingData == null ? 'Create User' : 'Update User',
        checkUnSavedData: true,
        endpointName: endpointName,
        objectInputType: widget.userConfig.saveUserInputType,
        inputObjectFieldName: widget.userConfig.saveUserInputFieldName,
        queryFields: 'uid otp',
        responseResults: (data, loading) {
          if (data != null) {
            Future.delayed(const Duration(milliseconds: 1000), () {
              NotificationService.info(
                  center: true,
                  context: context,
                  title: data['data']['otp'],
                  content:
                      'One Time Password (OTP) can only be used once and can expire after 30 minutes');
            });
            userRolesController.getUsers(context,
                endpointName: widget.userConfig.getUsersEndpoint,
                updateNewData: true,
                responseFields: widget.userConfig.getUserResponseFields);
          }
        },
        buildContext: context,
        formGroup: FormGroup(
          fieldController: fieldController,
          updateFields: updatingData,
          group: [
            Group(header: 'Soldier Details', children: [
              Obx(() {
                userRolesController.disableAllFields.value;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (userRolesController.userListData.isNotEmpty)
                      ListView(
                        shrinkWrap: true,
                        children: List.generate(
                          userRolesController.userListData.length,
                          (index) => Card(
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              dense: true,
                              tileColor: currentIndex == index
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.5)
                                  : null,
                              onTap: () {
                                currentIndex = index;
                                userRolesController
                                    .changeActiveStatus(currentIndex == index);
                                if (fieldController
                                    .field.fieldValuesController.instanceValues
                                    .where((element) => [
                                          'firstName',
                                          'middleName',
                                          'lastName',
                                          'comptNumber'
                                        ].contains(element.keys.first))
                                    .toList()
                                    .isNotEmpty) {
                                  for (var i = 0;
                                      i <
                                          fieldController
                                              .field
                                              .fieldValuesController
                                              .instanceValues
                                              .length;
                                      i++) {
                                    if ([
                                      'firstName',
                                      'middleName',
                                      'lastName',
                                      'comptNumber'
                                    ].contains(fieldController
                                        .field
                                        .fieldValuesController
                                        .instanceValues[i]
                                        .keys
                                        .first)) {
                                      fieldController
                                          .field.fieldValuesController
                                          .updateValue(
                                              userRolesController
                                                      .userListData[index][
                                                  fieldController
                                                      .field
                                                      .fieldValuesController
                                                      .instanceValues[i]
                                                      .keys
                                                      .first],
                                              fieldController
                                                  .field
                                                  .fieldValuesController
                                                  .instanceValues[i]
                                                  .keys
                                                  .first,
                                              i);
                                    }
                                  }
                                } else {
                                  Map<String, dynamic> mapData =
                                      userRolesController.userListData[index];
                                  mapData.forEach((key, value) {
                                    if ([
                                      'firstName',
                                      'middleName',
                                      'lastName',
                                      'comptNumber'
                                    ].contains(key)) {
                                      fieldController
                                          .field.fieldValuesController
                                          .addValue(Map<String, dynamic>.from({
                                        key: value,
                                        'inputType':
                                            value.runtimeType.toString()
                                      }));
                                    }
                                  });
                                }
                              },
                              subtitle: Text(
                                  'Comptroller Number: ${userRolesController.userListData[index]['comptrollerNumber']}'),
                              title: Text(
                                  '${userRolesController.userListData[index]['firstName']} ${userRolesController.userListData[index]['middleName']} ${userRolesController.userListData[index]['lastName']}'),
                            ),
                          ),
                        ),
                      ),
                    if (userRolesController.userListData.isNotEmpty)
                      const SizedBox(
                        height: 10,
                      ),
                    if (userRolesController.userListData.isNotEmpty &&
                        updatingData == null)
                      Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor: MaterialStatePropertyAll(
                                      ThemeController.getInstance().darkMode(
                                          darkColor: Colors.white24,
                                          lightColor:
                                              Theme.of(context).primaryColor))),
                              onPressed: () {
                                currentIndex = -1;
                                userRolesController.userListData.clear();
                                userRolesController.disableAllFields.value =
                                    false;
                                fieldController.field.fieldValuesController
                                    .clearInstance();
                                fieldController.updateField([]);
                              },
                              child: const Text('Go To Search'))),
                    if (userRolesController.userListData.isEmpty)
                      userDetailsController.field.input(
                          enabled: !userRolesController.loadingUser.value,
                          widthSize: WidthSize.col12,
                          context: context,
                          fieldInputType: FieldInputType.ServiceNumber,
                          validate: true,
                          inputType: 'int',
                          label: 'Service Number',
                          key: 'serviceNumber'),
                    if (userRolesController.userListData.isEmpty)
                      const SizedBox(
                        height: 10,
                      ),
                    if (userRolesController.loadingUser.value &&
                        userRolesController.userListData.isEmpty)
                      IndicateProgress.cardLinear('Loading User Details'),
                    if (!userRolesController.loadingUser.value &&
                        userRolesController.userListData.isEmpty)
                      Align(
                        alignment: Alignment.centerRight,
                        child: userDetailsController.field.button(
                            context: context,
                            label: 'Get Soldier Details',
                            onPressed: () {
                              userRolesController.getSoldierDetails(
                                  fieldData?['serviceNumber'], context);
                            }),
                      )
                  ],
                );
              })
            ]),
            Group(header: 'User Information', children: [
              Obx(() {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    fieldController.field.multiSelect(
                        context: context,
                        readOnly: !userRolesController.disableAllFields.value,
                        isPageable: true,
                        label: 'Facility',
                        inputType: 'String',
                        endPointName: 'getFacilities',
                        queryFields: 'name uid',
                        fieldInputType: FieldInputType.Other,
                        validate: true,
                        widthSize: WidthSize.col12,
                        key: 'facilityUids'),
                    fieldController.field.input(
                        enabled: userRolesController.disableAllFields.value,
                        context: context,
                        label: 'Phone',
                        inputType: 'String',
                        fieldInputType: FieldInputType.MobileNumber,
                        validate: true,
                        widthSize: WidthSize.col3,
                        key: 'phoneNumber'),
                    fieldController.field.input(
                        enabled: userRolesController.disableAllFields.value,
                        context: context,
                        label: 'Email',
                        inputType: 'String',
                        fieldInputType: FieldInputType.EmailAddress,
                        validate: true,
                        widthSize: WidthSize.col3,
                        key: 'email'),
                  ],
                );
              })
            ])
          ],
        )).show();
  }
}

class UserConfig {
  final String saveUserEndpoint;
  final String getUsersEndpoint;
  final String getUserResponseFields;
  // final String getPermissionsEndpoint;
  // final String getPermissionsResponseField;
  final String assignRoleToUserEndpoint;
  final String deleteUserEndpoint;
  final Map<String, dynamic> Function(Map<String, dynamic>)? mapFunction;
  final String? deleteUIdFieldName;
  final String saveUserInputFieldName;
  final String saveUserInputType;
  final String getRolesByUserResponseFields;
  final String getRolesByUserEndpoint;

  UserConfig(
      {required this.saveUserEndpoint,
      required this.getUsersEndpoint,
      required this.getUserResponseFields,
      // required this.getPermissionsEndpoint,
      // required this.getPermissionsResponseField,
      required this.assignRoleToUserEndpoint,
      required this.getRolesByUserEndpoint,
      required this.getRolesByUserResponseFields,
      this.mapFunction,
      this.deleteUIdFieldName,
      required this.saveUserInputFieldName,
      required this.saveUserInputType,
      required this.deleteUserEndpoint});
}
