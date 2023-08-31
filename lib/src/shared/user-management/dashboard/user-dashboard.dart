import 'package:flutter/material.dart';

import '../../../../shared_component.dart';
import 'dash-tile-data.dart';
import 'dash-tile.dart';
import 'user-per-role.dart';

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
  FieldController fieldConroller = FieldController();

  @override
  void initState() {
    fieldConroller.fieldUpdates.listen((event) {});
    super.initState();
  }

  @override
  void dispose() {
    fieldConroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mobileViewSize = MediaQuery.of(context).size.width < 700;
    return mobileViewSize
        ? mobileView()
        : Column(
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
                                    child: DashTile(
                                  count: '100',
                                  dashTileData: DashTileData(
                                      countOne: '12',
                                      nameOne: 'Online',
                                      countTwo: '121',
                                      nameTwo: 'Offline'),
                                  tileName: 'Number Of Visits',
                                  icon: Icons.network_check_sharp,
                                )),
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
                                    itemBuilder: (context, index) =>
                                        UserPerRole(
                                            roleName: 'Role Name',
                                            count: '12$index')),
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
                            child: Center(child: LayoutBuilder(
                                builder: (context, constraintSize) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Filter By Date',
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
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

  Widget mobileView() {
    double fullHeight = 400;
    double halfHeight = 200;
    return SingleChildScrollView(
      child: SizedBox(
        // height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                height: halfHeight,
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
                )),
            SizedBox(
              height: halfHeight,
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
            SizedBox(
                height: halfHeight,
                child: DashTile(
                  count: '100',
                  dashTileData: DashTileData(
                      countOne: '90',
                      nameOne: 'Male',
                      countTwo: '30',
                      nameTwo: 'Female'),
                  tileName: 'Users By Gender',
                  icon: Icons.transgender_sharp,
                )),
            SizedBox(
                height: halfHeight,
                child: DashTile(
                  count: '100',
                  dashTileData: DashTileData(
                      countOne: '12',
                      nameOne: 'Online',
                      countTwo: '121',
                      nameTwo: 'Offline'),
                  tileName: 'Number Of Visits',
                  icon: Icons.network_check_sharp,
                )),
            SizedBox(
              height: halfHeight,
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
            SizedBox(
                height: fullHeight,
                child: const Card(
                  child: Center(child: Text('Graph Here')),
                )),
            SizedBox(
              height: halfHeight,
              child: const Card(
                child: Center(child: Text('Rectangle Tile 1')),
              ),
            ),
            SizedBox(
              height: halfHeight,
              child: const Card(
                child: Center(child: Text('Rectangle Tile 2')),
              ),
            ),
            SizedBox(
              height: fullHeight,
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
            SizedBox(
              height: halfHeight,
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
          ],
        ),
      ),
    );
  }
}
