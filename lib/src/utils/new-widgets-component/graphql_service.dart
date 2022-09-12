import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_component/shared_component.dart' hide FetchPolicy;

import 'base_fields.dart';
import 'client.dart';
import 'other_parameters.dart';

class GraphQLService {
  static Map<String, dynamic>? _otherParams;

  static Future<List<Map<String,dynamic>>> queryPageable(
      {required String endPointName,
      required String responseFields,
      List<OtherParameters>? queryParameters,
      PageableParams pageableParams = const PageableParams(),
        required BuildContext context,
      String? optionResponseFields}) async{
    if (queryParameters != null) {
      for (var element in queryParameters) {
        _otherParams?.addAll({element.keyName: element.keyValue});
      }
    }
    final QueryOptions options = QueryOptions(
      document: gql('''
  query $endPointName{
    $endPointName{
        $pageableBaseFields
        data{
            ${optionResponseFields ?? responseFields}
        }
    }
}
  '''),
      variables: {...pageableParams.toJson(), ...?_otherParams},
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final client = graphClient();

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {}

    if (result.isLoading) {}
    List<Map<String,dynamic>>? repositories = result.data?[endPointName]?['data'].map((e) => e).cast<Map<String,dynamic>>().toList();

    if (result.data?[endPointName]?['status'] == false) {
      Toast.error(result.data?[endPointName]?['message']);
    }
    if (repositories == null) {}

        if (result.hasException) {
          LinkException exception = result.exception!.linkException!;
          if (exception.runtimeType == ServerException) {
           Toast.error('Connection Error');
          } else if (exception.runtimeType == HttpLinkServerException) {
            HttpLinkServerException serverException =
                exception as HttpLinkServerException;
            var errorResponse =
                serverException.parsedResponse!.response['message'].split(':');
            if (errorResponse[0] == "Invalid access token") {
              Toast.error(errorResponse[0]);
            }else{
              Toast.error('Something is wrong');
            }
            
          }
        }else{
          if(result.data?[endPointName] == null){

            List errorsList = result.exception!.graphqlErrors;
            NotificationService.errors(
                title: 'GraphQL Errors!',
                context: context!,
                contents: errorsList);

          }
        }
    return repositories ?? [];
  }

  static Future<List<Map<String,dynamic>>> query(
      {required String endPointName,
      required String responseFields,
      List<OtherParameters>? parameters,
        required BuildContext context,
      String? optionResponseFields}) async{
    if (parameters != null) {
      for (var element in parameters) {
        _otherParams?.addAll({element.keyName: element.keyValue});
      }
    }
    final QueryOptions options = QueryOptions(
      document: gql('''
  query $endPointName{
    $endPointName{
        $baseResponseFields
        data{
            ${optionResponseFields ?? responseFields}
        }
    }
}
  '''),
      variables: {...?_otherParams},
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    final client = graphClient();

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {}

    if (result.isLoading) {}
    List<Map<String,dynamic>>? repositories = result.data?[endPointName]?['data'].map((e) => e).cast<Map<String,dynamic>>().toList();

    if (result.data?[endPointName]?['status'] == false) {
      Toast.error(result.data?[endPointName]?['message']);
    }
    if (repositories == null) {}
    if (result.hasException) {
          LinkException exception = result.exception!.linkException!;
          if (exception.runtimeType == ServerException) {
           Toast.error('Connection Error');
          } else if (exception.runtimeType == HttpLinkServerException) {
            HttpLinkServerException serverException =
                exception as HttpLinkServerException;
            var errorResponse =
                serverException.parsedResponse!.response['message'].split(':');
            if (errorResponse[0] == "Invalid access token") {
              Toast.error(errorResponse[0]);
            }else{
              Toast.error('Something is wrong');
            }
            
          }
        }else{
      if(result.data?[endPointName] == null){

        List errorsList = result.exception!.graphqlErrors;
        NotificationService.errors(
            title: 'GraphQL Errors!',
            context: context!,
            contents: errorsList);

      }
    }
    return repositories ?? [];
  }



   static  mutate(
      {required Function(Map<String,dynamic>?,bool)? response,
      required String endPointName,
      required String queryFields,
        required List<InputParameter> inputs,
        required BuildContext context,
      String? optionResponseFields}) async{

     Map<String,dynamic> otherParams = {};
     if (inputs.isNotEmpty) {
       for (var element in inputs) {
         otherParams.addAll({element.fieldName: element.fieldValue});
       }
     }

    final MutationOptions options = MutationOptions(
            document: gql('''
  mutation $endPointName{
    $endPointName{
        $baseResponseFields
        data{
            ${optionResponseFields ?? queryFields}
        }
    }
}
  '''),
            variables: {
              ...otherParams
            },
            operationName: endPointName,
            fetchPolicy: FetchPolicy.networkOnly,
        /*    update: (GraphQLDataProxy? cache, QueryResult? result) {
              print(result!.isLoading);
              return cache;
            },*/
            );

     final client = graphClient();

     final QueryResult result = await client.value.mutate(options);

     if (result.hasException) {
       if(result.exception!.linkException != null){
         LinkException exception = result.exception!.linkException!;

         if (exception.runtimeType == ServerException) {
           Toast.error('Connection Error',subTitle: 'Check your Internet connection');
         } else if (exception.runtimeType == HttpLinkServerException) {
           HttpLinkServerException serverException =
           exception as HttpLinkServerException;
           var errorResponse =
           serverException.parsedResponse!.response['message'].split(':');
           if (errorResponse[0] == "Invalid access token") {
             Toast.error(errorResponse[0],subTitle: 'Logout and login again to refresh your token');
           }else if(errorResponse[0] =='Access token expired'){
             Toast.error(errorResponse[0]);
           }else{
             Toast.error('Something is wrong');
           }

         }
       }else{
         if(result.data?[endPointName] == null){

           List errorsList = result.exception!.graphqlErrors;
           NotificationService.errors(
             title: 'GraphQL Errors!',
               context: context,
               contents: errorsList);

         }
       }

     }
     if(response != null){
       response(result.data?[endPointName],result.isLoading);
     }

     if(result.data != null){
       if(result.data?[endPointName]['status']){
         Toast.info(result.data?[endPointName]['message'],subTitle: 'Data Saved Successfully');
       }else {
         Toast.error('Error',subTitle:result.data?[endPointName]['message']);
       }

     }

   return result.data?[endPointName]['data'];
  }
}

class InputParameter {
  final String fieldName;
  final dynamic fieldValue;

  InputParameter({required this.fieldName, required this.fieldValue});

}


class MutationExecute {
  final MutationHookResult mutation;
  final String endPointName;

  MutationExecute( {required this.endPointName,required this.mutation});

  execute({required List<InputParameter> inputs, Function(Map<String,dynamic>?,bool)? response})async{
    Map<String,dynamic> otherParams = {};
    if (inputs.isNotEmpty) {
      for (var element in inputs) {
        otherParams.addAll({element.fieldName: element.fieldValue});
      }
    }
    await mutation.runMutation({
      ...otherParams
    }).networkResult;
    if(response != null){
      response(mutation.result.data?[endPointName]['data'],mutation.result.isLoading);
    }

  }
}

class QueryExecute {
  final MutationHookResult query;
  final String endPointName;

  QueryExecute( {required this.endPointName,required this.query});

  execute({required List<InputParameter> inputs, Function(Map<String,dynamic>?,bool)? response})async{
    Map<String,dynamic> otherParams = {};
    if (inputs.isNotEmpty) {
      for (var element in inputs) {
        otherParams.addAll({element.fieldName: element.fieldValue});
      }
    }
    await query.runMutation({
      ...otherParams
    }).networkResult;
    if(response != null){
      response(query.result.data?[endPointName]['data'],query.result.isLoading);
    }

  }
}

class PageableParams{
  final int size;
  final int page;
  final String? searchKey;

  const PageableParams({this.size = 20, this.page = 1,this.searchKey});

   Map<String, dynamic> toJson() {
    return {
      'size': size,
      'page': page,
      'searchKey': searchKey,
    };
  }
}
