import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';
import 'package:shared_component/src/shared/user-management/details-card.dart';
import 'package:shared_component/src/shared/user-management/role-widget.dart';

import 'helper-classes.dart';
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

  @override
  void initState() {
    width = 0;
    // width = SizeConfig.fullScreen.width * 0.5;
    // _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  width = SizeConfig.fullScreen.width * 0.5;
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
                    title: 'Roles',
                    context: context,
                    child: const RoleWidget());
              },
            ),
          ),
        )),
        DetailCard(
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

  onPressDashboard() {
    setState(() {
      showDetails = !showDetails;
      if (!showDetails) {
        width = 0;
      } else {
        width = SizeConfig.fullScreen.width * 0.5;
      }
    });
  }

  createAndUpdateUser(
      {Map<String, dynamic>? updatingData, required String endpointName}) {
    PopupModel(
        buttonLabel: updatingData == null ? 'Create User' : 'Update User',
        title: updatingData == null ? 'Create User' : 'Update User',
        checkUnSavedData: true,
        endpointName: endpointName,
        inputType: 'SaveUserDtoInput',
        inputObjectFieldName: 'userDto',
        queryFields: 'uid',
        responseResults: (data, loading) {
          ///Todo: Implement sometning after submittion completed;
        },
        buildContext: context,
        formGroup: FormGroup(
          updateFields: updatingData,
          group: [
            Group(header: 'User Information', children: [
              Field.use.input(
                  context: context,
                  label: 'Full Name',
                  fieldInputType: FieldInputType.FullName,
                  validate: true,
                  inputType: 'String',
                  widthSize: WidthSize.col3,
                  key: 'name'),
              Field.use.input(
                  context: context,
                  label: 'Phone',
                  inputType: 'String',
                  fieldInputType: FieldInputType.MobileNumber,
                  validate: true,
                  widthSize: WidthSize.col3,
                  key: 'phoneNumber'),
              Field.use.input(
                  context: context,
                  label: 'Email',
                  inputType: 'String',
                  fieldInputType: FieldInputType.EmailAddress,
                  validate: true,
                  widthSize: WidthSize.col3,
                  key: 'email'),
              Field.use.select(
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

class Dashboard extends StatefulWidget {
  const Dashboard(
      {super.key,
      this.onFilterByDate,
      this.onRolesPressed,
      this.onUsersPressed,
      this.onActiveUsersPressed,
      this.onLockedUserPressed,
      this.onExpiredPressed,
      this.onLoginAttemptPressed});
  final Function(dynamic)? onFilterByDate;
  final Function()? onRolesPressed;
  final Function()? onUsersPressed;
  final Function()? onActiveUsersPressed;
  final Function()? onLockedUserPressed;
  final Function()? onExpiredPressed;
  final Function()? onLoginAttemptPressed;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Field fieldConroller = Field();

  @override
  void initState() {
    fieldConroller.fieldUpdates.listen((event) {
      console(event);
    });
    super.initState();
  }

  @override
  void dispose() {
    fieldConroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Top Tiles
        Expanded(
          child: Row(
            children: [
              ///Top Left Tiles
              Expanded(
                child: Row(
                  children: [
                    ///Top Tile Left Tiles
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                    child: DashTile(
                                  count: '21',
                                  tileName: 'Active Users',
                                  icon: Icons.verified_outlined,
                                  onTap: widget.onActiveUsersPressed,
                                )),
                                Expanded(
                                  child: DashTile(
                                    count: '7',
                                    tileName: 'Login Attempts',
                                    icon: Icons.login,
                                    onTap: widget.onLoginAttemptPressed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: DashTile(
                            count: '100',
                            dashTileData: DashTileData(
                                countOne: '90',
                                nameOne: 'Male',
                                countTwo: '30',
                                nameTwo: 'Female'),
                            tileName: 'Users By Gender',
                            icon: Icons.transgender_sharp,
                          ))
                        ],
                      ),
                    ),

                    ///Top Tile Right Tiles
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                    child: DashTile(
                                  count: '10',
                                  tileName: 'Locked Users',
                                  icon: Icons.lock,
                                  onTap: widget.onLockedUserPressed,
                                )),
                                Expanded(
                                    child: DashTile(
                                  count: '11',
                                  tileName: 'Expired Credentials',
                                  icon: Icons.manage_accounts_sharp,
                                  onTap: widget.onExpiredPressed,
                                )),
                              ],
                            ),
                          ),
                          Expanded(
                              child: DashTile(
                            count: '100',
                            dashTileData: DashTileData(
                                countOne: '12',
                                nameOne: 'Online',
                                countTwo: '121',
                                nameTwo: 'Offline'),
                            tileName: 'Number Of Visits',
                            icon: Icons.network_check_sharp,
                          ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              ///Top Right Graph
              const Expanded(
                  child: Card(
                child: Center(child: Text('Graph Here')),
              ))
            ],
          ),
        ),

        ///Bottom Tiles
        Expanded(
          child: Row(
            children: [
              ///First Segment
              const Expanded(
                  child: Column(
                children: [
                  Expanded(
                    child: Card(
                      child: Center(child: Text('Rectangle Tile 1')),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Center(child: Text('Rectangle Tile 2')),
                    ),
                  ),
                ],
              )),

              ///Second segment
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Users Per Role',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(),
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 100,
                              itemBuilder: (context, index) => UserPerRole(
                                  roleName: 'Role Name', count: '12$index')),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              ///Third segment
              Expanded(
                  child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: DashTile(
                            count: '10',
                            tileName: 'Roles',
                            icon: Icons.task,
                            onTap: widget.onRolesPressed,
                          ),
                        ),
                        Expanded(
                          child: DashTile(
                            count: '201',
                            tileName: 'Users',
                            icon: Icons.supervisor_account,
                            onTap: widget.onUsersPressed,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Center(child:
                          LayoutBuilder(builder: (context, constraintSize) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Filter By Date',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            SizedBox(
                              height: constraintSize.maxHeight * 0.05,
                            ),
                            fieldConroller.field.date(
                                disableFuture: true,
                                context: context,
                                validate: true,
                                label: 'Start Date',
                                key: 'startDate',
                                onSelectedDate: (data) {}),
                            SizedBox(
                              height: constraintSize.maxHeight * 0.1,
                            ),
                            fieldConroller.field.date(
                                disableFuture: true,
                                context: context,
                                label: 'End Date',
                                validate: true,
                                key: 'endDate',
                                onSelectedDate: (data) {}),
                          ],
                        );
                      })),
                    ),
                  ))
                ],
              ))
            ],
          ),
        )
      ],
    );
  }
}

class DashTile extends StatefulWidget {
  const DashTile(
      {super.key,
      required this.icon,
      required this.tileName,
      this.dashTileData,
      this.onTap,
      required this.count});
  final IconData? icon;
  final String? tileName;
  final String? count;
  final DashTileData? dashTileData;
  final Function()? onTap;

  @override
  State<DashTile> createState() => _DashTileState();
}

class _DashTileState extends State<DashTile> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: LayoutBuilder(builder: (context, constraintSize) {
        return Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomRight,
                        stops: [
                          0.5,
                          1
                        ],
                        colors: [
                          Color.fromARGB(0, 158, 158, 158),
                          Color.fromARGB(125, 220, 221, 209)
                        ]),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(4))),
                child: Stack(
                  children: [
                    ClipRect(
                      child: Align(
                        widthFactor: 0.5,
                        alignment: Alignment.centerRight,
                        child: Icon(
                          widget.icon,
                          size: constraintSize.maxHeight * 0.8,
                          color: const Color.fromARGB(37, 158, 158, 158),
                        ),
                      ),
                    ),
                    if (widget.dashTileData == null)
                      Center(
                        child: Text(
                          widget.count ?? '0',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    if (widget.dashTileData != null)
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      widget.dashTileData?.countOne ?? '0',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  color:
                                      const Color.fromARGB(49, 158, 158, 158),
                                  height: constraintSize.maxHeight * 0.1,
                                  child: Center(
                                      child: Text(
                                    widget.dashTileData?.nameOne ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          fontSize:
                                              constraintSize.maxHeight * 0.06,
                                        ),
                                  )),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      widget.dashTileData?.countTwo ?? '0',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  color:
                                      const Color.fromARGB(49, 158, 158, 158),
                                  height: constraintSize.maxHeight * 0.1,
                                  child: Center(
                                      child: Text(
                                    widget.dashTileData?.nameTwo ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          fontSize:
                                              constraintSize.maxHeight * 0.06,
                                        ),
                                  )),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
            InkWell(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(4)),
              onTap: widget.onTap,
              onHover: (value) {
                setState(() {
                  hovered = !hovered;
                });
              },
              child: SizedBox(
                height: constraintSize.maxHeight * 0.2,
                child: Center(
                    child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        left: !hovered
                            ? -constraintSize.maxWidth
                            : constraintSize.maxWidth * 0,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: constraintSize.maxWidth,
                            height: constraintSize.maxHeight,
                            alignment: Alignment.center,
                            child: Text(
                              'View Details',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      color: ThemeController.getInstance()
                                          .darkMode(
                                              darkColor: Colors.blue,
                                              lightColor: Theme.of(context)
                                                  .primaryColor)),
                            ),
                          ),
                        )),
                    AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        right: hovered
                            ? -constraintSize.maxWidth
                            : constraintSize.maxWidth * 0,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: constraintSize.maxWidth,
                            height: constraintSize.maxHeight,
                            alignment: Alignment.center,
                            child: Text(
                              widget.tileName ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      color: ThemeController.getInstance()
                                          .darkMode(
                                              darkColor: Colors.white38,
                                              lightColor: Colors.black38)),
                            ),
                          ),
                        )),
                  ],
                )),
              ),
            )
          ],
        );
      }),
    );
  }
}

class DashTileData {
  final String countOne;
  final String countTwo;
  final String nameOne;
  final String nameTwo;
  DashTileData(
      {required this.countOne,
      required this.countTwo,
      required this.nameOne,
      required this.nameTwo});
}

class UserPerRole extends StatelessWidget {
  const UserPerRole({super.key, required this.roleName, required this.count});
  final String? roleName;
  final String? count;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {},
        leading: const Icon(Icons.task),
        title: Text(roleName?.toUpperCase() ?? ''),
        trailing: Text(
          count ?? '',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
