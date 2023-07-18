import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_component/shared_component.dart';

import 'user-roles-controller.dart';

class UserListWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onTap;
  final Function() onExit;
  final Function() onCreateUser;

  const UserListWidget(
      {super.key,
      required this.onTap,
      required this.onExit,
      required this.onCreateUser});

  @override
  State<UserListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  ScrollController scrollController = ScrollController();
  UserRolesController userRolesController = Get.put(UserRolesController());
  TextEditingController textEditingController = TextEditingController();
  int stopCall = 2;

  @override
  void initState() {
    textEditingController.text = userRolesController.searchParam ?? '';
    userRolesController.getUsers(context);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        stopCall++;
        if (stopCall % 2 == 0) {
          userRolesController.getUsers(context);
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    userRolesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size sixe = SizeConfig.fullScreen;
    return Obx(() => SizedBox(
          // width: sixe.width,
          height: sixe.height,
          child: Scaffold(
            floatingActionButton: Tooltip(
                message: 'Create User',
                child: FloatingActionButton(
                  mini: true,
                  onPressed: widget.onCreateUser,
                  child: const Icon(Icons.add),
                )),
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            body: Card(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: textEditingController,
                          onChanged: (value) {
                            userRolesController.searchParam = value;
                            userRolesController.getUsers(context,
                                searchKey: value, onSearch: true);
                          },
                          decoration: const InputDecoration(
                              hintText: 'Search',
                              // fillColor: Colors.black12,
                              // filled: true,
                              prefixIcon: Icon(Icons.search_rounded)),
                        ),
                        userRolesController.loadingUsers.value
                            ? IndicateProgress.linear()
                            : LayoutBuilder(builder: (context, constraint) {
                                return ListTile(
                                  tileColor: const Color.fromARGB(13, 0, 0, 0),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'User Name',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Container(
                                          width: constraint.maxWidth * 0.13,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Facility',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          )),
                                    ],
                                  ),
                                );
                              }),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: ListView.builder(
                                    controller: scrollController,
                                    shrinkWrap: true,
                                    itemCount:
                                        userRolesController.usersList.length,
                                    itemBuilder: (context, index) {
                                      return LayoutBuilder(
                                          builder: (context, constraint) {
                                        return Card(
                                          child: ListTile(
                                              onTap: () {
                                                userRolesController
                                                    .getUserRolesByUser(
                                                        userRolesController
                                                                .usersList[
                                                            index]['uid'],
                                                        context);
                                                widget.onTap(userRolesController
                                                    .usersList[index]);
                                              },
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    userRolesController
                                                                .usersList[
                                                            index]['name'] ??
                                                        '',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                  Container(
                                                      width:
                                                          constraint.maxWidth *
                                                              0.13,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        userRolesController.usersList[
                                                                        index]
                                                                    ['facility']
                                                                ['name'] ??
                                                            '',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium,
                                                      )),
                                                ],
                                              )),
                                        );
                                      });
                                    }),
                              ),
                              userRolesController.noMoreData.value
                                  ? Container(
                                      height: 50,
                                      alignment: Alignment.center,
                                      child: const Text('No More Data!'),
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
                        onPressed: widget.onExit,
                        icon: const Icon(Icons.clear)),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
