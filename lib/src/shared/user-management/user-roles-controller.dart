import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';

class UserRolesController extends GetxController {
  List<Map<String, dynamic>> unAssignedRoleList = [];
  List<Map<String, dynamic>> storedRoles = [];
  RxList<Map<String, dynamic>> assgnedRoleList = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> usersList = [];
  final userListData = [].obs;
  final loading = false.obs;
  final loadingUsers = false.obs;
  final noMoreData = false.obs;
  final requestFailed = false.obs;
  final onSaveChangesLoader = false.obs;
  final loadingUser = false.obs;
  final disableAllFields = false.obs;
  String? responseMessage;
  int nextPage = 0;
  int totalPages = -1;
  int currentPage = 0;
  String? searchParam;

  ///response field mus contains name, description, active and uid
  getUserRolesByUser(String userUid, BuildContext context,
      {required String getRolesByUserEndpoint,
      required String getRolesByUserResponseFields}) async {
    loading.value = true;
    var res = await GraphQLService.query(
        endPointName: getRolesByUserEndpoint,
        responseFields: getRolesByUserResponseFields,
        // fetchPolicy: FetchPolicy
        parameters: [
          OtherParameters(
              keyName: 'userUid', keyValue: userUid, keyType: 'String')
        ],
        context: context);
    filterAssignedRoles(List<Map<String, dynamic>>.from(res.data));
    loading.value = false;
  }

  filterAssignedRoles(List<Map<String, dynamic>> roleList) {
    assgnedRoleList.value = [];
    assgnedRoleList.value =
        roleList.where((element) => element['active'] == true).toList();
    unAssignedRoleList =
        roleList.where((element) => element['active'] == false).toList();
    storedRoles = unAssignedRoleList;
  }

  getUsers(BuildContext context,
      {String? searchKey,
      bool onSearch = false,
      required String responseFields,
      required String endpointName,
      bool updateUserList = false,
      String? removeUserUid}) async {
    SettingsService.use.isEmptyOrNull(searchKey) ? null : nextPage = 0;
    loadingUsers.value = true;
    if (currentPage != totalPages && !updateUserList ||
        onSearch && !updateUserList) {
      var res = await GraphQLService.queryPageable(
          endPointName: endpointName,
          responseFields: responseFields,
          response: (PageableResponse? data, bool loading) {
            if (data != null && data.status) {
              currentPage = data.currentPage;
              nextPage = data.currentPage;
              totalPages = data.pages;
            } else {
              requestFailed.value = data?.status ?? true;
              responseMessage = data?.message ?? 'Failed To Fetch Data!';
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
    } else if (updateUserList) {
      usersList.removeWhere((element) => element['uid'] == removeUserUid);
      noMoreData.value = false;
      loadingUsers.value = false;
      return;
    }

    noMoreData.value = true;
    loadingUsers.value = false;
  }

  Future<List<Map<String, dynamic>>> getSoldierDetails(
      String serviceNumber, BuildContext context) async {
    loadingUser.value = true;

    final res = await GraphQLService.query(
        endPointName: 'getSoldierDetails',
        responseFields:
            'birthDate comptrollerNumber firstName lastName middleName ',
        parameters: [
          OtherParameters(
              keyName: 'serviceNumber',
              keyValue: serviceNumber,
              keyType: 'String')
        ],
        context: context);
    loadingUser.value = false;
    var resData = res.data
        .map((item) => Map<String, dynamic>.from(
            {...item, 'comptNumber': item['comptrollerNumber']}))
        .toList();
    userListData.value = List<Map<String, dynamic>>.from(resData);
    return List<Map<String, dynamic>>.from(res.data);
  }

  void saveChanges(
      {required String endPointName,
      required List<InputParameter> inputs,
      String? userUid,
      // bool isRole = false,
      required Function(Map<String, dynamic>?) onResponse,
      required BuildContext context}) {
    onSaveChangesLoader.value = true;
    List<InputParameter> data = inputs
        .map((e) => InputParameter(
            fieldName: e.fieldName,
            inputType: e.inputType,
            fieldValue:
                SettingsService.use.convertListOfMapToMap(e.fieldValue)))
        .toList();

    GraphQLService.mutate(
        updateUid: userUid,
        response: (data, loading) {
          onSaveChangesLoader.value = loading;
          if (data != null) {
            onResponse(data);
          }
        },
        endPointName: endPointName,
        queryFields: 'uid',
        inputs: data,
        context: context);
  }

  changeActiveStatus(bool status) {
    disableAllFields.value = status;
  }
}
