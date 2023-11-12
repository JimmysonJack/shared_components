import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';
import 'package:shared_component/src/shared/user-management/details_card.dart';
import 'package:shared_component/src/shared/user-management/role-widget.dart';

import 'helper-classes.dart';
import 'dashboard/user_dashboard.dart';
import 'user-list-widget.dart';

class UserManager extends StatefulWidget {
  const UserManager({super.key});

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
  FieldController fieldController = FieldController();

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
              onCreateUser: () {
                createAndUpdateUser(endpointName: 'saveUser');
              },
              onTap: (Map<String, dynamic> data) {
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
                    locked = userData['enabled'];
                    active = userData['isActive'];
                    credentialCanExpire = userData['credentialsNonExpired'];
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
                      title: 'Roles', context: context, child: RoleWidget());
                },
              ),
            ),
          )),
        DetailCard(
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
              passwordCanExpire: !credentialCanExpire,
              email: userData['email'],
              fullName: userData['name'],
              onDisabled: (value) {},
              onLocked: (value) {},
              onPasswordCanExpire: (value) {},
              phone: userData['phoneNumber'],
              region: userData['facility']?['name'],
              disabled: !active,
              isLoked: !locked),
          userUid: userData['uid'] ?? '',
          height: height,
          width: width,
          showDetails: showDetails,
          shakeIt: shakeIt,
          onEditUser: (data) {
            createAndUpdateUser(endpointName: 'updateUser', updatingData: data);
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
    PopupModel(
        fieldController: fieldController,
        buttonLabel: updatingData == null ? 'Create User' : 'Update User',
        title: updatingData == null ? 'Create User' : 'Update User',
        checkUnSavedData: true,
        endpointName: endpointName,
        objectInputType: 'SaveUserDtoInput',
        inputObjectFieldName: 'userDto',
        queryFields: 'uid',
        responseResults: (data, loading) {
          ///Todo: Implement sometning after submittion completed;
        },
        buildContext: context,
        formGroup: FormGroup(
          fieldController: fieldController,
          updateFields: updatingData,
          group: [
            Group(header: 'User Information', children: [
              fieldController.field.input(
                  context: context,
                  label: 'Full Name',
                  fieldInputType: FieldInputType.FullName,
                  validate: true,
                  inputType: 'String',
                  widthSize: WidthSize.col3,
                  key: 'name'),
              fieldController.field.input(
                  context: context,
                  label: 'Phone',
                  inputType: 'String',
                  fieldInputType: FieldInputType.MobileNumber,
                  validate: true,
                  widthSize: WidthSize.col3,
                  key: 'phoneNumber'),
              fieldController.field.input(
                  context: context,
                  label: 'Email',
                  inputType: 'String',
                  fieldInputType: FieldInputType.EmailAddress,
                  validate: true,
                  widthSize: WidthSize.col3,
                  key: 'email'),
              fieldController.field.select(
                  context: context,
                  isPageable: true,
                  label: 'Facility',
                  inputType: 'String',
                  endPointName: 'getFacilities',
                  queryFields: 'name uid',
                  fieldInputType: FieldInputType.Other,
                  validate: true,
                  widthSize: WidthSize.col3,
                  key: 'facility'),
            ])
          ],
        )).show();
  }
}
