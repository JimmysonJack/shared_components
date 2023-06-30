import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_component/shared_component.dart';

class UserRolesController extends GetxController {
  List<Map<String, dynamic>> unAssignedRoleList = [];
  RxList<Map<String, dynamic>> assgnedRoleList = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> usersList = [];
  final loading = false.obs;
  final loadingUsers = false.obs;
  final noMoreData = false.obs;
  int nextPage = 0;
  int totalPages = -1;
  int currentPage = 0;
  String? searchParam;

  getUserRolesByUser(String userUid, BuildContext context) async {
    loading.value = true;
    var res = await GraphQLService.query(
        endPointName: 'getRolesByUser',
        responseFields: 'name description active uid',
        // fetchPolicy: FetchPolicy
        parameters: [
          OtherParameters(
              keyName: 'userUid', keyValue: userUid, keyType: 'String')
        ],
        context: context);
    filterAssignedRoles(res);
    loading.value = false;
  }

  filterAssignedRoles(List<Map<String, dynamic>> roleList) {
    assgnedRoleList.value = [];
    assgnedRoleList.value =
        roleList.where((element) => element['active'] == true).toList();
    unAssignedRoleList =
        roleList.where((element) => element['active'] == false).toList();
  }

  getUsers(BuildContext context,
      {String? searchKey, bool onSearch = false}) async {
    SettingsService.use.isEmptyOrNull(searchKey) ? null : nextPage = 0;
    loadingUsers.value = true;
    if (currentPage != totalPages || onSearch) {
      var res = await GraphQLService.queryPageable(
          endPointName: 'getUsers',
          responseFields: '''
                    name 
                    email
                    facility{
                      uid 
                      name
                      } 
                      accountNonExpired
                      credentialsNonExpired
                      lastLogin
                      phoneNumber
                      enabled
                      isActive
                      uid
                      ''',
          response: (PageableResponse? data, bool loading) {
            if (data != null) {
              currentPage = data.currentPage;
              nextPage = data.currentPage;
              totalPages = data.pages;
            }
          },
          pageableParams: PageableParams(
              page: nextPage,
              size: 20,
              searchKey: SettingsService.use.isEmptyOrNull(searchKey)
                  ? searchParam
                  : searchKey),
          context: context);
      !SettingsService.use.isEmptyOrNull(searchKey)
          ? usersList = res
          : usersList.addAll(res);
      noMoreData.value = false;
      loadingUsers.value = false;
      return;
    }
    noMoreData.value = true;
    loadingUsers.value = false;
  }
}
