import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';

import 'user-roles-controller.dart';

class UserListWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onTap;
  final Function() onExit;
  final Function() onCreateUser;
  final String responseFields;
  final String endpointName;
  final String getRolesByUserResponseFields;
  final String getRolesByUserEndpoint;
  final UserRolesController userRolesController;

  const UserListWidget(
      {super.key,
      required this.onTap,
      required this.onExit,
      required this.endpointName,
      required this.getRolesByUserEndpoint,
      required this.getRolesByUserResponseFields,
      required this.responseFields,
      required this.userRolesController,
      required this.onCreateUser});

  @override
  State<UserListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  ScrollController scrollController = ScrollController();
  // UserRolesController userRolesController = Get.put(UserRolesController());
  TextEditingController textEditingController = TextEditingController();
  int stopCall = 2;
  bool showEmail = true;
  int currentSelected = -1;

  @override
  void initState() {
    textEditingController.text = widget.userRolesController.searchParam ?? '';
    widget.userRolesController.getUsers(context,
        endpointName: widget.endpointName,
        responseFields: widget.responseFields);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        stopCall++;
        if (stopCall % 2 == 0) {
          widget.userRolesController.getUsers(context,
              endpointName: widget.endpointName,
              responseFields: widget.responseFields);
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // userRolesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size sixe = SizeConfig.fullScreen;
    return Obx(() => SizedBox(
          // width: sixe.width,
          height: sixe.height,
          child: widget.userRolesController.requestFailed.value
              ? GErrorMessage(
                  icon: const Icon(Icons.error),
                  title: widget.userRolesController.responseMessage ?? '',
                  buttonLabel: 'Reload',
                  onPressed: () {
                    widget.userRolesController.requestFailed.value = false;
                    widget.userRolesController.getUsers(context,
                        endpointName: widget.endpointName,
                        responseFields: widget.responseFields);
                  },
                )
              : Scaffold(
                  floatingActionButton: Tooltip(
                      message: 'Create User',
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor:
                            ThemeController.getInstance().isDarkTheme.value
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                        onPressed: widget.onCreateUser,
                        child: const Icon(Icons.add),
                      )),
                  floatingActionButtonAnimator:
                      FloatingActionButtonAnimator.scaling,
                  body: Card(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: textEditingController,
                                onChanged: (value) {
                                  widget.userRolesController.searchParam =
                                      value;
                                  widget.userRolesController.getUsers(context,
                                      endpointName: widget.endpointName,
                                      responseFields: widget.responseFields,
                                      searchKey: value,
                                      onSearch: true);
                                },
                                decoration: const InputDecoration(
                                    hintText: 'Search',
                                    // fillColor: Colors.black12,
                                    // filled: true,
                                    prefixIcon: Icon(Icons.search_rounded)),
                              ),
                              widget.userRolesController.loadingUsers.value
                                  ? IndicateProgress.linear()
                                  : SettingsService.use.isEmptyOrNull(widget
                                              .userRolesController.usersList) &&
                                          !widget.userRolesController
                                              .loadingUsers.value
                                      ? Expanded(
                                          child: GErrorMessage(
                                            icon: const Icon(Icons.error),
                                            title: 'Nothing Found',
                                            buttonLabel: 'Reload',
                                            onPressed: () {
                                              widget.userRolesController
                                                  .getUsers(context,
                                                      endpointName:
                                                          widget.endpointName,
                                                      responseFields: widget
                                                          .responseFields);
                                            },
                                          ),
                                        )
                                      : LayoutBuilder(
                                          builder: (context, constraint) {
                                          return ListTile(
                                            tileColor: const Color.fromARGB(
                                                13, 0, 0, 0),
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  fit: FlexFit.tight,
                                                  child: Text(
                                                    'User Name',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                if (showEmail)
                                                  SizedBox(
                                                    width: constraint.maxWidth *
                                                        0.413,
                                                    child: Text(
                                                      'Email',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                Container(
                                                    width: constraint.maxWidth *
                                                        0.14,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'Active Facility',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )),
                                              ],
                                            ),
                                          );
                                        }),
                              if (!SettingsService.use.isEmptyOrNull(
                                  widget.userRolesController.usersList))
                                Flexible(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: ListView.builder(
                                            controller: scrollController,
                                            shrinkWrap: true,
                                            itemCount: widget
                                                .userRolesController
                                                .usersList
                                                .length,
                                            itemBuilder: (context, index) {
                                              return LayoutBuilder(builder:
                                                  (context, constraint) {
                                                return Card(
                                                  child: ListTile(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      tileColor:
                                                          currentSelected ==
                                                                  index
                                                              ? Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.5)
                                                              : null,
                                                      onTap: () {
                                                        currentSelected = index;
                                                        widget.userRolesController.getUserRolesByUser(
                                                            widget.userRolesController
                                                                    .usersList[
                                                                index]['uid'],
                                                            context,
                                                            getRolesByUserEndpoint:
                                                                widget
                                                                    .getRolesByUserEndpoint,
                                                            getRolesByUserResponseFields:
                                                                widget
                                                                    .getRolesByUserResponseFields);
                                                        showEmail = false;
                                                        widget.onTap(widget
                                                            .userRolesController
                                                            .usersList[index]);
                                                      },
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Flexible(
                                                            fit: FlexFit.tight,
                                                            child: Text(
                                                              widget.userRolesController
                                                                              .usersList[
                                                                          index]
                                                                      [
                                                                      'name'] ??
                                                                  '',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          if (showEmail)
                                                            SizedBox(
                                                              width: constraint
                                                                      .maxWidth *
                                                                  0.413,
                                                              child: Text(
                                                                widget.userRolesController
                                                                            .usersList[index]
                                                                        [
                                                                        'email'] ??
                                                                    '',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          Container(
                                                              width: constraint
                                                                      .maxWidth *
                                                                  0.14,
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                widget.userRolesController.usersList[index]
                                                                            [
                                                                            'facility']
                                                                        [
                                                                        'name'] ??
                                                                    '',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              )),
                                                        ],
                                                      )),
                                                );
                                              });
                                            }),
                                      ),
                                      widget.userRolesController.noMoreData
                                              .value
                                          ? Container(
                                              height: 50,
                                              alignment: Alignment.center,
                                              child:
                                                  const Text('No More Data!'),
                                            )
                                          : const SizedBox.shrink()
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                        Align(
                          alignment: const Alignment(1, -1),
                          child: IconButton(
                              onPressed: () {
                                showEmail = true;
                                widget.onExit();
                              },
                              icon: const Icon(Icons.clear)),
                        )
                      ],
                    ),
                  ),
                ),
        ));
  }
}
