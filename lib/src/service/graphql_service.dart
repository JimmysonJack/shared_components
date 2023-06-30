// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';
import 'package:shared_component/shared_component.dart';

import '../utils/new-widgets-component/base_fields.dart';

class GraphQLService {
  static GraphQLService? _instance;
  static GraphQLService _getInstance() {
    _instance ??= GraphQLService();
    return _instance!;
  }

  static GraphQLService get getService => _getInstance();
  String? endPoint;
  String? endPointName;

  static Future<List<Map<String, dynamic>>> queryPageable({
    required String endPointName,
    required String responseFields,
    Function(PageableResponse?, bool)? response,
    List<OtherParameters>? parameters,
    PageableParams pageableParams = const PageableParams(),
    FetchPolicy? fetchPolicy,
    required BuildContext context,
  }) async {
    Map<String, dynamic> otherParams = {};

    Map mapVariables = {};
    Map inputVariables = {};
    String? inputVariable = '';
    String? mapVariable = '';

    if (parameters != null) {
      for (var element in parameters) {
        mapVariables.addAll({'\$${element.keyName}': element.keyType});
        inputVariables.addAll({element.keyName: '\$${element.keyName}'});
        otherParams.addAll({element.keyName: element.keyValue});
      }
      mapVariable =
          mapVariables.toString().replaceAll('{', '').replaceAll('}', '');
      inputVariable =
          inputVariables.toString().replaceAll('{', '').replaceAll('}', '');
    }
    var endpoint = '''
  query $endPointName($pageableFields $mapVariable){
    $endPointName($pageableValue  $inputVariable){
        $pageableBaseFields
        data{
           $responseFields
        }
    }
}
  ''';
    // GraphQLService.getService.endPoint = _endpoint;
    // GraphQLService.getService.endPointName = endPointName;
    final QueryOptions options = QueryOptions(
      document: gql(endpoint),
      variables: {'pageableParam': pageableParams.toJson(), ...otherParams},
      fetchPolicy: fetchPolicy ?? FetchPolicy.networkOnly,
    );

    final client = await graphClient(context);

    final QueryResult result = await client.value.query(options);

    if (result.isLoading) {}
    List<Map<String, dynamic>>? repositories = result.data?[endPointName]
            ?['data']
        .map((e) => e)
        .cast<Map<String, dynamic>>()
        .toList();

    if (response != null) {
      var data = result.data == null
          ? null
          : PageableResponse.fromJson(result.data![endPointName]);
      response(data, result.isLoading);
    }

    if (result.data?[endPointName]?['status'] == false) {
      NotificationService.snackBarError(
        context: context,
        title: result.data?[endPointName]?['message'],
      );
    }
    if (repositories == null) {}

    if (result.hasException) {
      LinkException exception = result.exception!.linkException!;
      if (exception.runtimeType == ServerException) {
        NotificationService.snackBarError(
          context: context,
          title: 'Connection Error',
        );
      } else if (exception.runtimeType == HttpLinkServerException) {
        HttpLinkServerException serverException =
            exception as HttpLinkServerException;
        if (serverException.parsedResponse!.response.keys.contains('message')) {
          var errorResponse =
              serverException.parsedResponse!.response['message'].split(':');
          if (errorResponse[0] == "Invalid access token") {
            NotificationService.snackBarError(
              context: context,
              title: errorResponse[0],
            );
          }
        } else if (serverException.parsedResponse!.response.keys
            .contains('error_description')) {
          var errorResponse = serverException
              .parsedResponse!.response['error_description']
              .split(':');
          if (errorResponse[0] == "Invalid access token") {
            NotificationService.snackBarError(
              context: context,
              title: errorResponse[0],
            );
          }
        } else {
          NotificationService.snackBarError(
            context: context,
            title: 'Something is wrong',
          );
        }
      }
    } else {
      if (result.data?[endPointName] == null) {
        List errorsList = result.exception!.graphqlErrors;
        NotificationService.errors(
            title: 'GraphQL Errors!', context: context, contents: errorsList);
      }
    }
    return repositories ?? [];
  }

  static Future<List<Map<String, dynamic>>> query(
      {required String endPointName,
      required String responseFields,
      List<OtherParameters>? parameters,
      FetchPolicy? fetchPolicy,
      required BuildContext context,
      String? optionResponseFields}) async {
    Map<String, dynamic>? otherParams = {};
    Map values = {};
    Map variables = {};
    if (parameters != null) {
      for (var element in parameters) {
        variables.addAll({'\$${element.keyName}': element.keyType});
        values.addAll({element.keyName: '\$${element.keyName}'});
        otherParams.addAll({element.keyName: element.keyValue});
      }
    }
    var graphVariables =
        variables.toString().replaceAll('{', '').replaceAll('}', '');
    var graphValues = values.toString().replaceAll('{', '').replaceAll('}', '');
    var withParams = '''
  query $endPointName($graphVariables){
    $endPointName($graphValues){
        $baseResponseFields
        data{
            ${optionResponseFields ?? responseFields}
        }
    }
}
  ''';

    var withoutParams = '''
  query $endPointName{
    $endPointName{
        $baseResponseFields
        data{
            ${optionResponseFields ?? responseFields}
        }
    }
}
  ''';
    final QueryOptions options = QueryOptions(
      document: gql(parameters != null ? withParams : withoutParams),
      variables: {...otherParams},
      fetchPolicy: fetchPolicy ?? FetchPolicy.networkOnly,
    );

    final client = await graphClient(context);

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {}

    if (result.isLoading) {}
    List<Map<String, dynamic>>? repositories = result.data?[endPointName]
            ?['data']
        .map((e) => e)
        .cast<Map<String, dynamic>>()
        .toList();

    if (result.data?[endPointName]?['status'] == false) {
      NotificationService.snackBarError(
        context: context,
        title: result.data?[endPointName]?['message'],
      );
    }
    if (repositories == null) {}
    if (result.hasException) {
      LinkException exception = result.exception!.linkException!;
      if (exception.runtimeType == ServerException) {
        NotificationService.snackBarError(
          context: context,
          title: 'Connection Error',
        );
      } else if (exception.runtimeType == HttpLinkServerException) {
        HttpLinkServerException serverException =
            exception as HttpLinkServerException;
        var errorResponse =
            serverException.parsedResponse!.response['message'].split(':');
        if (errorResponse[0] == "Invalid access token") {
          NotificationService.snackBarError(
            context: context,
            title: errorResponse[0],
          );
        } else {
          NotificationService.snackBarError(
            context: context,
            title: 'Something is wrong',
          );
        }
      }
    } else {
      if (result.data?[endPointName] == null) {
        List errorsList = result.exception!.graphqlErrors;
        NotificationService.errors(
            title: 'GraphQL Errors!', context: context, contents: errorsList);
      }
    }
    return repositories ?? [];
  }

  ///This [response]is used to return server response and loading state.
  ///
  /// This [endPointName] is used to pass graphql endpoint.
  ///
  ///  This [queryFields] is used to pass the response fields that you want to be returned.
  ///
  /// Is used to pass a custom [successMessage] that is being displayed when the request is success.
  ///
  /// [refetchData] is a boolean whisch helps us to decide if we want to refetch a dataTable after a completion of a request.
  ///
  /// [inputs] this param is used to pass Parameters of the [endPointName]
  static mutate(
      {required Function(Map<String, dynamic>?, bool)? response,
      required String endPointName,
      required String queryFields,
      String? successMessage,
      bool refetchData = false,
      required List<InputParameter> inputs,
      required BuildContext context,
      String? optionResponseFields}) async {
    DataTableController dataTableController = Get.put(DataTableController());
    Map<String, dynamic> otherParams = {};
    Map mapVariables = {};
    Map inputVariables = {};
    String? inputVariable;
    String? mapVariable;
    if (inputs.isNotEmpty) {
      for (var element in inputs) {
        mapVariables.addAll({'\$${element.fieldName}': element.inputType});
        inputVariables.addAll({element.fieldName: '\$${element.fieldName}'});
        if (element.objectValues != null) {
          otherParams.addAll(
              {element.fieldName: convertListToMap(element.objectValues!)});
        } else {
          otherParams.addAll({element.fieldName: element.fieldValue});
        }
      }
      mapVariable =
          mapVariables.toString().replaceAll('{', '').replaceAll('}', '');
      inputVariable =
          inputVariables.toString().replaceAll('{', '').replaceAll('}', '');
    }

    final MutationOptions options = MutationOptions(
      document: gql('''
  mutation $endPointName($mapVariable){
    $endPointName($inputVariable){
        $baseResponseFields
        data{
            ${optionResponseFields ?? queryFields}
        }
    }
}
  '''),
      variables: {...otherParams},
      operationName: endPointName,
      fetchPolicy: FetchPolicy.networkOnly,
      update: (GraphQLDataProxy? cache, QueryResult? result) {
        // if (result?.data != null) UpdateTable.change.setUpdateTable(true);
        // final queryRequest = QueryOptions(document: gql(GraphQLService.getService.endPoint ?? "")).asRequest;
        // final newResult = result?.data?[endPointName]['data'];
        // final  data = cache?.readQuery(queryRequest);
        // final List<Map<String,dynamic>> dataList = data?[GraphQLService.getService.endPointName]['data'].map((element) => element).cast<Map<String,dynamic>>().toList();
        // final List<Map<String,dynamic>> items = dataList..insert(0, newResult);
        // data?[GraphQLService.getService.endPointName]['data'] = items;
        // cache?.writeQuery(queryRequest, data: data!);
      },
    );

    final client = await graphClient(context);

    final QueryResult result = await client.value.mutate(options);

    if (result.hasException) {
      if (result.exception!.linkException != null) {
        LinkException exception = result.exception!.linkException!;

        if (exception.runtimeType == ServerException) {
          NotificationService.snackBarError(
              context: context,
              title: 'Connection Error',
              subTitle: 'Check your Internet connection');
        } else if (exception.runtimeType == HttpLinkServerException) {
          HttpLinkServerException serverException =
              exception as HttpLinkServerException;
          if (serverException.parsedResponse!.response.keys
              .contains('message')) {
            var errorResponse =
                serverException.parsedResponse!.response['message'].split(':');
            _exceptionMessageHandler(errorResponse, context);
          }
          if (serverException.parsedResponse!.response.keys
              .contains('error_description')) {
            var errorResponse = serverException
                .parsedResponse!.response['error_description']
                .split(':');
            _exceptionMessageHandler(errorResponse, context);
          }
        }
      } else {
        if (result.data?[endPointName] == null) {
          List errorsList = result.exception!.graphqlErrors;
          NotificationService.errors(
              title: 'GraphQL Errors!', context: context, contents: errorsList);
        }
      }
    }
    if (response != null) {
      dataTableController.onLoadMore.value = result.isLoading;
      if (result.data?[endPointName] != null &&
          !result.hasException &&
          result.data?[endPointName]?['data'] != null &&
          refetchData) {
        RebuildToRefetch.instance().refetch();
      }
      response(result.data?[endPointName], result.isLoading);
    }

    if (result.data != null) {
      if (result.data?[endPointName]['status']) {
        NotificationService.snackBarSuccess(
            context: context,
            title: result.data?[endPointName]['message'],
            subTitle: successMessage ?? 'Changes Saved Successfully');
      } else {
        NotificationService.snackBarError(
            context: context,
            title: 'Error',
            subTitle: result.data?[endPointName]['message']);
      }
    }

    return result.data?[endPointName]['data'];
  }

  static _exceptionMessageHandler(List errorResponse, BuildContext context) {
    if (errorResponse[0] == "Invalid access token") {
      NotificationService.snackBarError(
          context: context,
          title: errorResponse[0],
          subTitle: 'Logout and login again to refresh your token');
    } else if (errorResponse[0] == 'Access token expired') {
      NotificationService.snackBarError(
          context: context, title: errorResponse[0]);
    } else {
      NotificationService.snackBarError(
          context: context, title: 'Something is wrong');
    }
  }
}

Map<String, dynamic> convertListToMap(List<InputParameter> list) {
  Map<String, dynamic> convertedListToMap = {};
  for (InputParameter element in list) {
    convertedListToMap.addAll({element.fieldName: element.fieldValue});
  }
  return convertedListToMap;
}

class InputParameter {
  final String fieldName;
  final List<InputParameter>? objectValues;
  final String inputType;
  final dynamic fieldValue;

  InputParameter(
      {required this.fieldName,
      this.fieldValue,
      this.objectValues,
      required this.inputType});
}

// class MutationExecute {
//   final MutationHookResult mutation;
//   final String endPointName;

//   MutationExecute( {required this.endPointName,required this.mutation});

//   execute({required List<InputParameter> inputs, Function(Map<String,dynamic>?,bool)? response})async{
//     Map<String,dynamic> otherParams = {};
//     if (inputs.isNotEmpty) {
//       for (var element in inputs) {
//         otherParams.addAll({element.fieldName: element.fieldValue});
//       }
//     }
//     await mutation.runMutation({
//       ...otherParams
//     }).networkResult;
//     if(response != null){
//       response(mutation.result.data?[endPointName]['data'],mutation.result.isLoading);
//     }

//   }
// }

// class QueryExecute {
//   final MutationHookResult query;
//   final String endPointName;

//   QueryExecute( {required this.endPointName,required this.query});

//   execute({required List<InputParameter> inputs, Function(Map<String,dynamic>?,bool)? response})async{
//     Map<String,dynamic> otherParams = {};
//     if (inputs.isNotEmpty) {
//       for (var element in inputs) {
//         otherParams.addAll({element.fieldName: element.fieldValue});
//       }
//     }
//     await query.runMutation({
//       ...otherParams
//     }).networkResult;
//     if(response != null){
//       response(query.result.data?[endPointName]['data'],query.result.isLoading);
//     }

//   }
// }

class PageableParams {
  final int size;
  final int page;
  final String? searchKey;

  const PageableParams({this.size = 20, this.page = 0, this.searchKey});

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'page': page,
      'searchParam': searchKey,
    };
  }
}

class PageableResponse {
  final int currentPage;
  final List<Map<String, dynamic>> data;
  final String message;
  final int numberOfElements;
  final int pages;
  final int size;
  final bool status;

  PageableResponse(
      {required this.currentPage,
      required this.data,
      required this.message,
      required this.numberOfElements,
      required this.pages,
      required this.size,
      required this.status});

  factory PageableResponse.fromJson(Map<String, dynamic> map) {
    return PageableResponse(
        currentPage: map['currentPage'] as int,
        data: List<Map<String, dynamic>>.from(map['data'] as List),
        message: map['message'] as String,
        numberOfElements: map['numberOfElements'] as int,
        pages: map['pages'] as int,
        size: map['size'] as int,
        status: map['status'] as bool);
  }

  Map<String, dynamic> toMap() {
    return {
      'currentPage': currentPage,
      'data': data,
      'message': message,
      'numberOfElements': numberOfElements,
      'pages': pages,
      'size': size,
      'status': status
    };
  }
}
