import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_component/shared_component.dart';

class ExceptionBuilder extends StatelessWidget {
  final OperationException exception;
  final bool hasData;
  final VoidCallback refetch;
  const ExceptionBuilder(
      {Key? key,
        required this.exception,
        required this.hasData,
        required this.refetch})
      : super(key: key);

  Widget _resolver(BuildContext context) {
    if ((exception.linkException is LinkException)) {
      print("YES ITS TYPELINK");
      return  Center(
        child: GErrorMessage(
            icon: const Icon(Icons.wifi_off),
            buttonLabel: 'Retry',
            onPressed: refetch,
            title: 'Network Error'),
      );
    } else if (exception.graphqlErrors.isNotEmpty) {
      print("YES ITS TYPELINKxxx");
      List<String> errors = exception.graphqlErrors[0].message.split(':');

      if (errors[1] == " JWTExpired") {
        return const Center(
          child: GErrorMessage(
              icon: Icon(Icons.token),
              // buttonLabel: 'Retry',
              // onPressed: refetch,
              title: 'Session Expired'),
        );
      }
      return GErrorMessage(
          icon: const Icon(Icons.warning_amber_rounded),
          buttonLabel: 'Retry',
          onPressed: refetch,
          title: 'Something went wrong');
    }

    return const SliverToBoxAdapter(
      child: SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _resolver(context);
  }
}
 class ResponseResolver {
  static _isNull(data){
    return data == null;
  }
   static  resolve(
      {required BuildContext context,
      required QueryResult result,
      required FetchMore fetchMore,
      required Refetch refetch,
        required String endPointName,
        TableAddButton? tableAddButton,
        required Function(List<Map<String,dynamic>> data) onData,
      }) {
     if (result.isLoading && _isNull(result.data)) {
       return IndicateProgress.circular();
     }

     // if (!_isNull(result.data)) {
     //   if(result.data?[endPointName]['data'].isNotEmpty){
     //     onData(result.data?[endPointName].map((e) => e).cast<Map<String,dynamic>>()).toList();
     //     return Container();
     //   }else{
     //     return GErrorMessage(
     //         icon: const Icon(Icons.error),
     //         buttonLabel: tableAddButton?.buttonName ?? '',
     //         onPressed: tableAddButton?.onPressed,
     //         title: 'No Data Yet');
     //   }
     // }
     if (result.hasException) {
       print("IN IN HERE");
       return [
         ExceptionBuilder(
             exception: result.exception!,
             hasData: _isNull(result.data),
             refetch: refetch)
       ];
     }

     return [
       const SliverToBoxAdapter(
         child: SizedBox.shrink(),
       )
     ];
   }
 }

class TableAddButton {
  final String buttonName;
  final Function() onPressed;

  TableAddButton({required this.onPressed, required this.buttonName});
}
