// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';

import 'helper-classes.dart';
import 'role-list-widget.dart';
import 'selected-roles-widget.dart';
import 'user-roles-controller.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class DetailCard extends StatefulWidget {
  final double height;
  final double width;
  final bool showDetails;
  final bool shakeIt;
  final String userUid;
  final LoggedInUserDetails? loggedInUserDetails;
  final Map<String, dynamic> user;
  final UserDetails? userDetails;
  final Function() onDeleteUser;
  final Function() onCloseDetailes;
  final String updateUserEndpoint;
  final String getRolesByUserEndpoint;
  final String getRolesByUserResponseFields;
  final String assignRoleToUserEndpoint;
  final String getUserResponseFields;
  final String getUserEndpointName;
  final FieldController fieldController;
  final UserRolesController userRolesController;

  final Function(Map<String, dynamic> data) onEditUser;
  const DetailCard(
      {super.key,
      required this.fieldController,
      required this.height,
      required this.userRolesController,
      required this.onCloseDetailes,
      required this.userUid,
      this.userDetails,
      required this.user,
      this.loggedInUserDetails,
      required this.width,
      required this.shakeIt,
      required this.onEditUser,
      required this.onDeleteUser,
      required this.getRolesByUserEndpoint,
      required this.getRolesByUserResponseFields,
      required this.updateUserEndpoint,
      required this.getUserEndpointName,
      required this.getUserResponseFields,
      required this.assignRoleToUserEndpoint,
      required this.showDetails});

  @override
  State<DetailCard> createState() => _DetailCardState();
}

class _DetailCardState extends State<DetailCard> {
  List<Map<String, dynamic>> selectedList = [];

  bool animateSelected = false;
  bool animateRoleList = false;
  Map<String, dynamic> selectedData = {};
  double? userDetailHeight;
  double? roleDetailHeight;
  double opacityLevel = 1.0;
  Curve curves = Curves.easeInToLinear;
  int duration = 500;

  bool deleteUserLoader = false;
  bool resetUserLoader = false;
  bool saveUserLoader = false;

  List<Map<String, dynamic>>? userInfors;
  List<String> selectedRoles = [];

  @override
  void initState() {
    widget.userRolesController.getUserRolesByUser(widget.userUid, context,
        getRolesByUserEndpoint: widget.getRolesByUserEndpoint,
        getRolesByUserResponseFields: widget.getRolesByUserResponseFields);
    widget.fieldController.fieldUpdates.listen((event) {
      userInfors = event['data'];
      console(userInfors);
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DetailCard oldWidget) {
    widget.fieldController.field.fieldValuesController.clearInstance();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool mobileSize = MediaQuery.of(context).size.width < 700;
    return mobileSize && widget.width != 0
        ? mobileView()
        : AnimatedContainer(
            color: Theme.of(context).scaffoldBackgroundColor,
            duration: const Duration(milliseconds: 1000),
            width: widget.width,
            curve: Curves.fastOutSlowIn,
            child: TweenAnimationBuilder<double>(
                tween:
                    Tween<double>(begin: 1.0, end: widget.shakeIt ? 0.8 : 1.0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: SizedBox(
                      child: AnimatedCrossFade(
                          firstChild: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(40),
                              child: SizedBox(
                                height: widget.height,
                                // width: width,
                                child: LayoutBuilder(
                                    builder: (context, constraint) {
                                  return Obx(() => Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 40,
                                                    backgroundColor:
                                                        ThemeController
                                                                .getInstance()
                                                            .darkMode(
                                                                darkColor: Colors
                                                                    .white24,
                                                                lightColor: Colors
                                                                    .black12),
                                                    child: Icon(
                                                      Icons.person,
                                                      size: 60,
                                                      color: ThemeController
                                                              .getInstance()
                                                          .darkMode(
                                                              darkColor: Colors
                                                                  .white38,
                                                              lightColor: Colors
                                                                  .black26),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            widget.userDetails
                                                                    ?.fullName ??
                                                                ' Name Not Available',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headlineSmall
                                                                ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        17,
                                                                    color: ThemeController.getInstance().darkMode(
                                                                        darkColor:
                                                                            Colors
                                                                                .white54,
                                                                        lightColor:
                                                                            Colors.grey)),
                                                          ),
                                                          const SizedBox(
                                                            width: 30,
                                                          ),
                                                          Tooltip(
                                                            message:
                                                                'Edit User',
                                                            child: IconButton(
                                                                onPressed: () {
                                                                  widget.onEditUser(
                                                                      widget
                                                                          .user);
                                                                },
                                                                icon: Icon(
                                                                  Icons.edit,
                                                                  color: Colors
                                                                      .red[500],
                                                                )),
                                                          )
                                                        ],
                                                      ),
                                                      Text(
                                                        '${widget.userDetails?.email ?? ' Not Available'}  |  ${widget.userDetails?.phone ?? 'Not Provided'}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        widget.userDetails
                                                                ?.region ??
                                                            'Not Provided',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  deleteUserLoader
                                                      ? Container(
                                                          width: 150,
                                                          alignment:
                                                              Alignment.center,
                                                          child:
                                                              IndicateProgress
                                                                  .circular())
                                                      : TextButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            fixedSize:
                                                                const Size(
                                                                    150, 40),
                                                            // shadowColor: Colors.black,
                                                            foregroundColor: ThemeController
                                                                    .getInstance()
                                                                .darkMode(
                                                                    darkColor:
                                                                        Colors
                                                                            .white54,
                                                                    lightColor:
                                                                        Colors
                                                                            .black87),
                                                            backgroundColor:
                                                                Colors.red
                                                                    .withOpacity(
                                                                        0.3),
                                                          ),
                                                          onPressed: () {
                                                            deleteUser(
                                                                widget.userUid);
                                                          },
                                                          child: const Text(
                                                              'Delete User')),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  resetUserLoader
                                                      ? Container(
                                                          width: 150,
                                                          alignment:
                                                              Alignment.center,
                                                          child:
                                                              IndicateProgress
                                                                  .circular(),
                                                        )
                                                      : TextButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            fixedSize:
                                                                const Size(
                                                                    150, 40),
                                                            // shadowColor: Colors.black,
                                                            foregroundColor: ThemeController
                                                                    .getInstance()
                                                                .darkMode(
                                                                    darkColor:
                                                                        Colors
                                                                            .white54,
                                                                    lightColor:
                                                                        Colors
                                                                            .black87),
                                                            backgroundColor:
                                                                const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        54,
                                                                        209,
                                                                        244)
                                                                    .withOpacity(
                                                                        0.3),
                                                          ),
                                                          onPressed: () {
                                                            resetUser(
                                                                widget.userUid);
                                                          },
                                                          child: const Text(
                                                              'Reset Password')),
                                                ],
                                              ),
                                            ],
                                          ),

                                          ///IS LOCKED ACTION
                                          SizedBox(
                                            height: constraint.maxHeight * 0.05,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'User is Locked',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                        color: widget.userDetails
                                                                        ?.isLoked ==
                                                                    true ||
                                                                widget
                                                                    .fieldController
                                                                    .field
                                                                    .fieldValuesController
                                                                    .instanceValues
                                                                    .where((element) =>
                                                                        element[
                                                                            'accountNonLocked'] ==
                                                                        true)
                                                                    .isNotEmpty
                                                            ? Colors.amber
                                                            : null),
                                              ),
                                              widget.fieldController.field
                                                  .toggle(
                                                context: context,
                                                onChanged: ((value) {
                                                  for (var element in widget
                                                      .fieldController
                                                      .instanceValues) {
                                                    if (element.keys.first ==
                                                        'accountNonLocked') {
                                                      widget.fieldController
                                                          .updateValue(
                                                              !value!,
                                                              'accountNonLocked',
                                                              widget
                                                                  .fieldController
                                                                  .instanceValues
                                                                  .indexOf(
                                                                      element));
                                                    }
                                                  }
                                                  // for (var element in widget
                                                  //     .fieldController
                                                  //     .field
                                                  //     .fieldValuesController
                                                  //     .instanceValues) {
                                                  //   widget.fieldController.field
                                                  //       .fieldValuesController
                                                  //       .updateValue(
                                                  //           !value!,
                                                  //           'accountNonLocked',
                                                  //           widget.fieldController
                                                  //               .instanceValues
                                                  //               .indexOf(element));
                                                  // }
                                                  setState(() {});
                                                }),
                                                currentValue: widget
                                                        .userDetails?.isLoked ??
                                                    false,
                                                inputType: 'Boolean',
                                                key: 'accountNonLocked',
                                              ),
                                            ],
                                          ),
                                          const Divider(),

                                          ///USER ACCESS ACTIONS
                                          SizedBox(
                                            height: constraint.maxHeight * 0.02,
                                          ),
                                          AnimatedOpacity(
                                            curve: curves,
                                            duration: Duration(
                                                milliseconds: duration),
                                            opacity: opacityLevel,
                                            child: AnimatedContainer(
                                              curve: curves,
                                              duration: Duration(
                                                  milliseconds: duration),
                                              height: userDetailHeight ??
                                                  constraint.maxHeight * 0.3,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child:
                                                        SingleChildScrollView(
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'User Access Actions',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall,
                                                          ),

                                                          ///USER DISABLED
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'User Is Disabled',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleMedium!
                                                                    .copyWith(
                                                                      color: widget.userDetails?.disabled == true ||
                                                                              widget.fieldController.field.fieldValuesController.instanceValues.where((element) => element['enabled'] == true).isNotEmpty
                                                                          ? Colors.amber
                                                                          : null,
                                                                    ),
                                                              ),
                                                              widget
                                                                  .fieldController
                                                                  .field
                                                                  .checkBox(
                                                                onChanged:
                                                                    (value) {
                                                                  for (var element
                                                                      in widget
                                                                          .fieldController
                                                                          .instanceValues) {
                                                                    if (element
                                                                            .keys
                                                                            .first ==
                                                                        'enabled') {
                                                                      widget.fieldController.updateValue(
                                                                          !value!,
                                                                          'enabled',
                                                                          widget
                                                                              .fieldController
                                                                              .instanceValues
                                                                              .indexOf(element));
                                                                    }
                                                                  }
                                                                  setState(
                                                                      () {});
                                                                },
                                                                currentValue: widget
                                                                        .userDetails
                                                                        ?.disabled ??
                                                                    false,
                                                                context:
                                                                    context,
                                                                key: 'enabled',
                                                                inputType:
                                                                    'Boolean',
                                                              ),
                                                            ],
                                                          ),

                                                          ///PASSWORD CAN EXPIRE
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'User Password Can Expire',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleMedium!
                                                                    .copyWith(
                                                                      color: widget.userDetails?.passwordCanExpire == true ||
                                                                              widget.fieldController.field.fieldValuesController.instanceValues.where((element) => element['passwordCanExpire'] == true).isNotEmpty
                                                                          ? Colors.amber
                                                                          : null,
                                                                    ),
                                                              ),
                                                              widget
                                                                  .fieldController
                                                                  .field
                                                                  .checkBox(
                                                                onChanged:
                                                                    (value) {
                                                                  setState(
                                                                      () {});
                                                                },
                                                                currentValue: widget
                                                                        .userDetails
                                                                        ?.passwordCanExpire ??
                                                                    false,
                                                                context:
                                                                    context,
                                                                key:
                                                                    'passwordCanExpire',
                                                                inputType:
                                                                    'Boolean',
                                                              ),
                                                            ],
                                                          ),

                                                          ///IF PASSWORD EXPIRED
                                                          widget.userDetails
                                                                      ?.passwordExpired ??
                                                                  false
                                                              ? Text(
                                                                  'Password Expired',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .labelSmall
                                                                      ?.copyWith(
                                                                          color:
                                                                              Colors.red[400]),
                                                                )
                                                              : const SizedBox(),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 100,
                                                    width: 1,
                                                    child: DecoratedBox(
                                                      decoration: BoxDecoration(
                                                          color: ThemeController
                                                                  .getInstance()
                                                              .darkMode(
                                                                  darkColor: Colors
                                                                      .white38,
                                                                  lightColor: Colors
                                                                      .black38)),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child:
                                                        SingleChildScrollView(
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        // crossAxisAlignment:
                                                        //     CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            'Last Login',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall,
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            DateFormat(
                                                                    'MMM d, yyyy HH:mm')
                                                                .format(DateTime.parse(widget
                                                                        .loggedInUserDetails
                                                                        ?.lastLogin ??
                                                                    '2022-03-27 0814')),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelLarge,
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'Logged In Device',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall,
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            widget.loggedInUserDetails ==
                                                                    null
                                                                ? 'Not Provided'
                                                                : '${widget.loggedInUserDetails?.loggedInDevice?.devicename} | Mac: ${widget.loggedInUserDetails?.loggedInDevice?.macAddress} | OS: ${widget.loggedInUserDetails?.loggedInDevice?.operatingSystem} | IP: ${widget.loggedInUserDetails?.loggedInDevice?.ipAddress}',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelLarge,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'Last Logged In Location',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall,
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            widget.loggedInUserDetails
                                                                    ?.lastLoginLocation ??
                                                                'Not Provided',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelLarge,
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'Authenticated Divice',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall,
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            widget.loggedInUserDetails ==
                                                                    null
                                                                ? 'Not Provided'
                                                                : '${widget.loggedInUserDetails?.authenticatedDevice?.devicename} | Mac: ${widget.loggedInUserDetails?.authenticatedDevice?.macAddress} | OS: ${widget.loggedInUserDetails?.authenticatedDevice?.operatingSystem} | IP: ${widget.loggedInUserDetails?.authenticatedDevice?.ipAddress}',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelLarge,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: constraint.maxHeight * 0.02,
                                          ),
                                          const Divider(),

                                          SizedBox(
                                            height: constraint.maxHeight * 0.02,
                                          ),
                                          widget.userRolesController
                                                  .onSaveChangesLoader.value
                                              ? IndicateProgress.cardLinear(
                                                  'Saving Changes')
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Role Section',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium,
                                                    ),
                                                    TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          fixedSize: const Size(
                                                              150, 40),
                                                          // shadowColor: Colors.black,
                                                          foregroundColor: ThemeController
                                                                  .getInstance()
                                                              .darkMode(
                                                                  darkColor: Colors
                                                                      .white54,
                                                                  lightColor: Colors
                                                                      .black87),
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.3),
                                                        ),
                                                        onPressed: () {
                                                          NotificationService
                                                              .confirm(
                                                            context: context,
                                                            showCancelBtn: true,
                                                            content:
                                                                'Are You Sure?',
                                                            confirmBtnText:
                                                                'Save',
                                                            cancelBtnText:
                                                                'Cancel',
                                                            title:
                                                                'Saving User Changes!',
                                                            onConfirmBtnTap:
                                                                () {
                                                              console(
                                                                  selectedRoles);
                                                              if (!SettingsService
                                                                      .use
                                                                      .isEmptyOrNull(
                                                                          selectedRoles) &&
                                                                  SettingsService
                                                                      .use
                                                                      .isEmptyOrNull(
                                                                          userInfors)) {
                                                                console(
                                                                    '......xxx.......saving roles');

                                                                ///Saving Role Here
                                                                widget
                                                                    .userRolesController
                                                                    .saveChanges(
                                                                        responseFields:
                                                                            widget
                                                                                .getUserResponseFields,
                                                                        onResponse:
                                                                            (data) {
                                                                          selectedRoles
                                                                              .clear();
                                                                        },
                                                                        endPointName:
                                                                            widget
                                                                                .assignRoleToUserEndpoint,
                                                                        inputs: [
                                                                          InputParameter(
                                                                              fieldName: 'userRolesDto',
                                                                              fieldValue: List<Map<String, dynamic>>.from([
                                                                                {
                                                                                  'userUid': widget.userUid,
                                                                                  'inputType': 'String'
                                                                                },
                                                                                {
                                                                                  'roles': selectedRoles,
                                                                                  'inputType': '[String]'
                                                                                }
                                                                              ]),
                                                                              inputType: 'UserRolesDtoInput'),
                                                                        ],
                                                                        context:
                                                                            context);
                                                                Navigator.pop(
                                                                    NavigationService
                                                                        .get
                                                                        .currentContext!,
                                                                    true);
                                                              }
                                                              if (!SettingsService
                                                                      .use
                                                                      .isEmptyOrNull(
                                                                          userInfors) &&
                                                                  SettingsService
                                                                      .use
                                                                      .isEmptyOrNull(
                                                                          selectedRoles)) {
                                                                console(
                                                                    ',...............zzzz......saving User info');

                                                                ///Saving UserInfor here
                                                                widget
                                                                    .userRolesController
                                                                    .saveChanges(
                                                                        responseFields: widget
                                                                            .getUserResponseFields,
                                                                        userUid:
                                                                            widget
                                                                                .userUid,
                                                                        onResponse:
                                                                            (data) {
                                                                          userInfors!
                                                                              .clear();
                                                                        },
                                                                        endPointName:
                                                                            widget
                                                                                .updateUserEndpoint,
                                                                        inputs: [
                                                                          InputParameter(
                                                                              fieldName: 'userDto',
                                                                              fieldValue: userInfors,
                                                                              inputType: 'UserDtoInput'),
                                                                        ],
                                                                        context:
                                                                            context);
                                                                Navigator.pop(
                                                                    NavigationService
                                                                        .get
                                                                        .currentContext!,
                                                                    true);
                                                              }

                                                              if (!SettingsService
                                                                      .use
                                                                      .isEmptyOrNull(
                                                                          userInfors) &&
                                                                  !SettingsService
                                                                      .use
                                                                      .isEmptyOrNull(
                                                                          selectedRoles)) {
                                                                console(
                                                                    'Saving both of them.................');
                                                                widget
                                                                    .userRolesController
                                                                    .saveChanges(
                                                                        responseFields: widget
                                                                            .getUserResponseFields,
                                                                        userUid:
                                                                            widget
                                                                                .userUid,
                                                                        onResponse:
                                                                            (data) {
                                                                          userInfors!
                                                                              .clear();

                                                                          ///Saving Role Here
                                                                          widget.userRolesController.saveChanges(
                                                                              responseFields: widget.getUserResponseFields,
                                                                              onResponse: (data) {
                                                                                selectedRoles.clear();
                                                                              },
                                                                              endPointName: widget.assignRoleToUserEndpoint,
                                                                              inputs: [
                                                                                InputParameter(fieldName: 'roleUids', fieldValue: selectedRoles, inputType: 'String'),
                                                                                InputParameter(fieldName: 'userUid', fieldValue: widget.userUid, inputType: 'String'),
                                                                              ],
                                                                              context: context);
                                                                        },
                                                                        endPointName:
                                                                            widget
                                                                                .updateUserEndpoint,
                                                                        inputs: [
                                                                          InputParameter(
                                                                              fieldName: 'userDto',
                                                                              fieldValue: userInfors,
                                                                              inputType: 'UserDtoInput'),
                                                                        ],
                                                                        context:
                                                                            context);

                                                                Navigator.pop(
                                                                    NavigationService
                                                                        .get
                                                                        .currentContext!,
                                                                    true);
                                                              }

                                                              if (SettingsService
                                                                      .use
                                                                      .isEmptyOrNull(
                                                                          userInfors) &&
                                                                  SettingsService
                                                                      .use
                                                                      .isEmptyOrNull(
                                                                          selectedRoles)) {
                                                                NotificationService
                                                                    .snackBarWarn(
                                                                        context:
                                                                            context,
                                                                        title:
                                                                            'No Changes Detected!');
                                                              }
                                                            },
                                                          );
                                                        },
                                                        child: const Text(
                                                            'Save Changes')),
                                                  ],
                                                ),
                                          Flexible(
                                            child: AnimatedContainer(
                                              curve: curves,
                                              duration: Duration(
                                                  milliseconds: duration),
                                              height: roleDetailHeight,
                                              child: MouseRegion(
                                                onEnter: (value) {
                                                  setState(() {
                                                    roleDetailHeight =
                                                        constraint.maxHeight *
                                                            0.8;
                                                    userDetailHeight =
                                                        constraint.maxHeight *
                                                            0.03;
                                                    opacityLevel = 0;
                                                  });
                                                },
                                                onExit: (value) {
                                                  setState(() {
                                                    userDetailHeight = null;
                                                    roleDetailHeight = null;
                                                    opacityLevel = 1.0;
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: RolesListWidget(
                                                        animate: selectedData,
                                                        onSearch: (searchKey) {
                                                          var roleList = widget
                                                              .userRolesController
                                                              .storedRoles;
                                                          setState(() {
                                                            if (searchKey
                                                                .isNotEmpty) {
                                                              widget.userRolesController.unAssignedRoleList = roleList
                                                                  .where((element) => element[
                                                                          'name']
                                                                      .toString()
                                                                      .toLowerCase()
                                                                      .contains(
                                                                          searchKey
                                                                              .toLowerCase()))
                                                                  .toList();
                                                            }
                                                          });
                                                        },
                                                        roleList: widget
                                                            .userRolesController
                                                            .unAssignedRoleList,
                                                        onSelected: (data) {
                                                          widget
                                                              .userRolesController
                                                              .assgnedRoleList
                                                              .add(data);
                                                          selectedRoles
                                                              .add(data['uid']);
                                                          widget
                                                              .userRolesController
                                                              .unAssignedRoleList
                                                              .remove(data);
                                                          setState(() {});
                                                        },
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Obx(() {
                                                        return SelectedRoleWidget(
                                                          animate: selectedData,
                                                          selectedList: widget
                                                              .userRolesController
                                                              .assgnedRoleList
                                                              .value,
                                                          onDelete: (data) {
                                                            widget
                                                                .userRolesController
                                                                .assgnedRoleList
                                                                .remove(data);
                                                            selectedRoles
                                                                .remove(data[
                                                                    'uid']);
                                                            widget
                                                                .userRolesController
                                                                .unAssignedRoleList
                                                                .insert(
                                                                    0, data);
                                                            setState(() {});
                                                          },
                                                        );
                                                      }),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ));
                                }),
                              ),
                            ),
                          ),
                          secondChild: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                height: widget.height,
                              ),
                            ),
                          ),
                          crossFadeState: widget.showDetails
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 1000)),
                    ),
                  );
                }));
  }

  Widget mobileView() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 5000),
      opacity: widget.width > 0 ? 1 : 0,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 32,
        child: LayoutBuilder(builder: (context, constraint) {
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: ThemeController.getInstance().darkMode(
                            darkColor: Colors.white24,
                            lightColor: Colors.black12),
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: ThemeController.getInstance().darkMode(
                              darkColor: Colors.white38,
                              lightColor: Colors.black26),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.userDetails?.fullName ??
                                    ' Name Not Available',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: ThemeController.getInstance()
                                            .darkMode(
                                                darkColor: Colors.white54,
                                                lightColor: Colors.grey)),
                              ),
                            ],
                          ),
                          Text(
                            '${widget.userDetails?.email ?? ' Not Available'}  |  ${widget.userDetails?.phone ?? 'Not Provided'}',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.userDetails?.region ?? 'Not Provided',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: constraint.maxHeight * 0.02,
                  ),
                  Row(
                    // mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment:
                    // CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      deleteUserLoader
                          ? Container(
                              width: 150,
                              alignment: Alignment.center,
                              child: IndicateProgress.circular())
                          : TextButton(
                              style: TextButton.styleFrom(
                                fixedSize: const Size(150, 40),
                                // shadowColor: Colors.black,
                                foregroundColor: ThemeController.getInstance()
                                    .darkMode(
                                        darkColor: Colors.white54,
                                        lightColor: Colors.black87),
                                backgroundColor: Colors.red.withOpacity(0.3),
                              ),
                              onPressed: () {
                                deleteUser(widget.userUid);
                              },
                              child: const Text('Delete User')),
                      resetUserLoader
                          ? Container(
                              width: 150,
                              alignment: Alignment.center,
                              child: IndicateProgress.circular(),
                            )
                          : TextButton(
                              style: TextButton.styleFrom(
                                fixedSize: const Size(150, 40),
                                // shadowColor: Colors.black,
                                foregroundColor: ThemeController.getInstance()
                                    .darkMode(
                                        darkColor: Colors.white54,
                                        lightColor: Colors.black87),
                                backgroundColor:
                                    const Color.fromARGB(255, 54, 209, 244)
                                        .withOpacity(0.3),
                              ),
                              onPressed: () {
                                resetUser(widget.userUid);
                              },
                              child: const Text('Reset Password')),
                    ],
                  ),
                  const Divider(),
                  SizedBox(
                    height: constraint.maxHeight * 0.02,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'User is Locked',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    widget.fieldController.field.toggle(
                                      context: context,
                                      currentValue:
                                          widget.userDetails?.isLoked ?? false,
                                      inputType: 'Boolean',
                                      key: 'accountNonLocked',
                                    ),
                                  ],
                                ),
                                Tooltip(
                                  message: 'Edit User',
                                  child: IconButton(
                                      onPressed: () =>
                                          widget.onEditUser(widget.user),
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.red[500],
                                      )),
                                )
                              ],
                            ),
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'User Access Actions',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),

                              ///USER DISABLED
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'User Is Disabled',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  widget.fieldController.field.checkBox(
                                    currentValue:
                                        widget.userDetails?.disabled ?? false,
                                    context: context,
                                    key: 'enabled',
                                    inputType: 'Boolean',
                                  ),
                                ],
                              ),

                              ///PASSWORD CAN EXPIRE
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'User Password Can Expire',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  widget.fieldController.field.checkBox(
                                    currentValue:
                                        widget.userDetails?.passwordCanExpire ??
                                            false,
                                    context: context,
                                    key: 'passwordCanExpire',
                                    inputType: 'Boolean',
                                  ),
                                ],
                              ),

                              ///IF PASSWORD EXPIRED
                              widget.userDetails?.passwordExpired ?? false
                                  ? Text(
                                      'Password Expired',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(color: Colors.red[400]),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            // crossAxisAlignment:
                            //     CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Last Login',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                DateFormat('MMM d, yyyy HH:mm').format(
                                    DateTime.parse(
                                        widget.loggedInUserDetails?.lastLogin ??
                                            '2022-03-27 0814')),
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Last Logged In Device',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.loggedInUserDetails == null
                                    ? 'Not Provided'
                                    : '${widget.loggedInUserDetails?.loggedInDevice?.devicename} | Mac: ${widget.loggedInUserDetails?.loggedInDevice?.macAddress} | OS: ${widget.loggedInUserDetails?.loggedInDevice?.operatingSystem} | IP: ${widget.loggedInUserDetails?.loggedInDevice?.ipAddress}',
                                style: Theme.of(context).textTheme.labelLarge,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Last Logged In Location',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.loggedInUserDetails?.lastLoginLocation ??
                                    'Not Provided',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Authenticated Divice',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.loggedInUserDetails == null
                                    ? 'Not Provided'
                                    : '${widget.loggedInUserDetails?.authenticatedDevice?.devicename} | Mac: ${widget.loggedInUserDetails?.authenticatedDevice?.macAddress} | OS: ${widget.loggedInUserDetails?.authenticatedDevice?.operatingSystem} | IP: ${widget.loggedInUserDetails?.authenticatedDevice?.ipAddress}',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Roles List',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            constraints: const BoxConstraints(
                                minHeight: 100, maxHeight: 300),
                            child: RolesListWidget(
                              animate: selectedData,
                              onSearch: (searchKey) {
                                var roleList =
                                    widget.userRolesController.storedRoles;
                                setState(() {
                                  if (searchKey.isNotEmpty) {
                                    widget.userRolesController
                                            .unAssignedRoleList =
                                        roleList
                                            .where((element) => element['name']
                                                .toString()
                                                .toLowerCase()
                                                .contains(
                                                    searchKey.toLowerCase()))
                                            .toList();
                                  }
                                });
                              },
                              roleList:
                                  widget.userRolesController.unAssignedRoleList,
                              onSelected: (data) {
                                widget.userRolesController.assgnedRoleList
                                    .add(data);
                                selectedRoles.add(data['uid']);
                                widget.userRolesController.unAssignedRoleList
                                    .remove(data);
                                setState(() {});
                              },
                            ),
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Active Roles',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            constraints: const BoxConstraints(
                                minHeight: 100, maxHeight: 300),
                            child: Obx(() => SelectedRoleWidget(
                                  animate: selectedData,
                                  selectedList: widget.userRolesController
                                      .assgnedRoleList.value,
                                  onDelete: (data) {
                                    widget.userRolesController.assgnedRoleList
                                        .remove(data);
                                    selectedRoles.remove(data['uid']);
                                    widget
                                        .userRolesController.unAssignedRoleList
                                        .insert(0, data);
                                    setState(() {});
                                  },
                                )),
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 20,
                          ),
                          widget.userRolesController.onSaveChangesLoader.value
                              ? IndicateProgress.cardLinear('Saving Changes')
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    TextButton(
                                        style: TextButton.styleFrom(
                                          fixedSize: const Size(150, 40),
                                          // shadowColor: Colors.black,
                                          foregroundColor:
                                              ThemeController.getInstance()
                                                  .darkMode(
                                                      darkColor: Colors.white54,
                                                      lightColor:
                                                          Colors.black87),
                                          backgroundColor: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.3),
                                        ),
                                        onPressed: () {
                                          console('............save change');
                                          NotificationService.confirm(
                                            context: context,
                                            showCancelBtn: true,
                                            content: 'Are You Sure?',
                                            confirmBtnText: 'Save',
                                            cancelBtnText: 'Cancel',
                                            title: 'Saving User Changes!',
                                            onConfirmBtnTap: () {
                                              console(selectedRoles);
                                              if (!SettingsService.use
                                                      .isEmptyOrNull(
                                                          selectedRoles) &&
                                                  SettingsService.use
                                                      .isEmptyOrNull(
                                                          userInfors)) {
                                                console(
                                                    '......xxx.......saving roles');

                                                ///Saving Role Here
                                                widget.userRolesController
                                                    .saveChanges(
                                                        responseFields: widget
                                                            .getUserResponseFields,
                                                        onResponse: (data) {
                                                          selectedRoles.clear();
                                                        },
                                                        endPointName: widget
                                                            .assignRoleToUserEndpoint,
                                                        inputs: [
                                                          InputParameter(
                                                              fieldName:
                                                                  'roleUids',
                                                              fieldValue:
                                                                  selectedRoles,
                                                              inputType:
                                                                  'String'),
                                                          InputParameter(
                                                              fieldName:
                                                                  'userUid',
                                                              fieldValue: widget
                                                                  .userUid,
                                                              inputType:
                                                                  'String'),
                                                        ],
                                                        context: context);
                                                Navigator.pop(
                                                    NavigationService
                                                        .get.currentContext!,
                                                    true);
                                              }
                                              if (!SettingsService.use
                                                      .isEmptyOrNull(
                                                          userInfors) &&
                                                  SettingsService.use
                                                      .isEmptyOrNull(
                                                          selectedRoles)) {
                                                console(
                                                    ',...............zzzz......saving User info');

                                                ///Saving UserInfor here
                                                widget.userRolesController
                                                    .saveChanges(
                                                        responseFields: widget
                                                            .getUserResponseFields,
                                                        userUid: widget.userUid,
                                                        onResponse: (data) {
                                                          userInfors!.clear();
                                                        },
                                                        endPointName: widget
                                                            .updateUserEndpoint,
                                                        inputs: [
                                                          InputParameter(
                                                              fieldName:
                                                                  'userDto',
                                                              fieldValue:
                                                                  userInfors,
                                                              inputType:
                                                                  'UserDtoInput'),
                                                        ],
                                                        context: context);
                                                Navigator.pop(
                                                    NavigationService
                                                        .get.currentContext!,
                                                    true);
                                              }

                                              if (!SettingsService.use
                                                      .isEmptyOrNull(
                                                          userInfors) &&
                                                  !SettingsService.use
                                                      .isEmptyOrNull(
                                                          selectedRoles)) {
                                                console(
                                                    'Saving both of them.................');
                                                widget.userRolesController
                                                    .saveChanges(
                                                        responseFields: widget
                                                            .getUserResponseFields,
                                                        userUid: widget.userUid,
                                                        onResponse: (data) {
                                                          userInfors!.clear();

                                                          ///Saving Role Here
                                                          widget
                                                              .userRolesController
                                                              .saveChanges(
                                                                  responseFields:
                                                                      widget
                                                                          .getUserResponseFields,
                                                                  onResponse:
                                                                      (data) {
                                                                    selectedRoles
                                                                        .clear();
                                                                  },
                                                                  endPointName:
                                                                      widget
                                                                          .assignRoleToUserEndpoint,
                                                                  inputs: [
                                                                    InputParameter(
                                                                        fieldName:
                                                                            'roleUids',
                                                                        fieldValue:
                                                                            selectedRoles,
                                                                        inputType:
                                                                            'String'),
                                                                    InputParameter(
                                                                        fieldName:
                                                                            'userUid',
                                                                        fieldValue:
                                                                            widget
                                                                                .userUid,
                                                                        inputType:
                                                                            'String'),
                                                                  ],
                                                                  context:
                                                                      context);
                                                        },
                                                        endPointName: widget
                                                            .updateUserEndpoint,
                                                        inputs: [
                                                          InputParameter(
                                                              fieldName:
                                                                  'userDto',
                                                              fieldValue:
                                                                  userInfors,
                                                              inputType:
                                                                  'UserDtoInput'),
                                                        ],
                                                        context: context);

                                                Navigator.pop(
                                                    NavigationService
                                                        .get.currentContext!,
                                                    true);
                                              }

                                              if (SettingsService.use
                                                      .isEmptyOrNull(
                                                          userInfors) &&
                                                  SettingsService.use
                                                      .isEmptyOrNull(
                                                          selectedRoles)) {
                                                NotificationService.snackBarWarn(
                                                    context: context,
                                                    title:
                                                        'No Changes Detected!');
                                              }
                                            },
                                          );
                                        },
                                        child: const Text('Save Changes')),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      widget.onCloseDetailes();
                    },
                    icon: const Icon(Icons.clear)),
              )
            ],
          );
        }),
      ),
    );
  }

  deleteUser(String userUid) {
    // deleteUserLoader = true;
    NotificationService.confirmWarn(
        context: context,
        title: 'You\'re Deleting This User!',
        content: 'Are You Sure?',
        cancelBtnText: 'No',
        confirmBtnText: 'Yes',
        buttonColor: const Color.fromARGB(172, 243, 92, 81),
        showCancelBtn: true,
        onConfirmBtnTap: () {
          setState(() {
            deleteUserLoader = true;
          });
          Navigator.pop(NavigationService.get.currentContext!, true);
          GraphQLService.mutate(
              successMessage: 'User is deleted Successfully',
              response: (value, loader) {
                setState(() {
                  deleteUserLoader = loader;
                  if (value != null) {
                    widget.userRolesController.getUsers(context,
                        endpointName: widget.getUserEndpointName,
                        responseFields: widget.getUserResponseFields,
                        updateUserList: true,
                        removeUserUid: widget.userUid);
                    widget.onDeleteUser();
                  }
                });
              },
              endPointName: 'deleteUser',
              queryFields: 'uid',
              inputs: [
                InputParameter(
                    fieldName: 'userUid',
                    inputType: 'String',
                    fieldValue: userUid)
              ],
              context: context);
        });
  }

  resetUser(String userUid) {
    NotificationService.confirmInfo(
        context: context,
        title: 'Are You Sure?',
        content:
            'You\'re about to reset a password for this user! \n Do you want to Proceed??',
        cancelBtnText: 'No',
        confirmBtnText: 'Yes',
        showCancelBtn: true,
        onConfirmBtnTap: () {
          setState(() {
            resetUserLoader = true;
          });
          Navigator.pop(NavigationService.get.currentContext!, true);
          GraphQLService.mutate(
              successMessage: 'Reset Completed Successfully',
              response: (data, loader) {
                setState(() {
                  resetUserLoader = loader;
                  if (data != null) {
                    NotificationService.info(
                        center: true,
                        context: context,
                        title: data['data']['otp'],
                        content:
                            'One Time Password (OTP) can only be used once and can expire after 30 minutes');
                  }
                });
              },
              endPointName: 'resetUserPassword',
              queryFields: 'uid otp',
              inputs: [
                InputParameter(
                    fieldName: 'userUid',
                    inputType: 'String',
                    fieldValue: userUid)
              ],
              context: context);
        });
  }

  // saveChanges() {}
}
