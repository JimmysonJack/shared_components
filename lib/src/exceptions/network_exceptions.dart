// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:ferry/ferry.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// part 'network_exceptions.freezed.dart';
//
// @freezed
//  class NetworkExceptions with _$NetworkExceptions{
//
//   const factory NetworkExceptions.requestCancelled() = RequestCancelled;
//
//   const factory NetworkExceptions.unauthorizedRequest() = UnauthorizedRequest;
//
//   const factory NetworkExceptions.badRequest() = BadRequest;
//
//   const factory NetworkExceptions.notFound(String reason) = NotFound;
//
//   const factory NetworkExceptions.methodNotAllowed() = MethodNotAllowed;
//
//   const factory NetworkExceptions.notAcceptable() = NotAcceptable;
//
//   const factory NetworkExceptions.requestTimeout() = RequestTimeout;
//
//   const factory NetworkExceptions.sendTimeout() = SendTimeout;
//
//   const factory NetworkExceptions.conflict() = Conflict;
//
//   const factory NetworkExceptions.internalServerError() = InternalServerError;
//
//   const factory NetworkExceptions.notImplemented() = NotImplemented;
//
//   const factory NetworkExceptions.serviceUnavailable() = ServiceUnavailable;
//
//   const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;
//
//   const factory NetworkExceptions.formatException() = FormatException;
//
//   const factory NetworkExceptions.unableToProcess() = UnableToProcess;
//
//   const factory NetworkExceptions.defaultError(String error) = DefaltError;
//
//   const factory NetworkExceptions.unexpectedError() = UnexpectedError;
//
//   static NetworkExceptions getDioException(error){
//     if(error is Exception){
//       try{
//         NetworkExceptions networkExceptions;
//         if(error is DioError){
//           switch(error.type){
//             case DioErrorType.cancel:
//               networkExceptions =  const NetworkExceptions.requestCancelled();
//               break;
//             case DioErrorType.connectTimeout:
//               networkExceptions =  const NetworkExceptions.requestTimeout();
//               break;
//             case DioErrorType.sendTimeout:
//               networkExceptions =  const NetworkExceptions.sendTimeout();
//               break;
//             case DioErrorType.receiveTimeout:
//               networkExceptions =  const NetworkExceptions.sendTimeout();
//               break;
//             case DioErrorType.other:
//               networkExceptions =  const NetworkExceptions.noInternetConnection();
//               break;
//             case DioErrorType.response:
//               switch(error.response?.statusCode){
//                 case 400:
//                   networkExceptions =  const NetworkExceptions.unauthorizedRequest();
//                   break;
//                 case 401:
//                   networkExceptions =  const NetworkExceptions.unauthorizedRequest();
//                   break;
//                 case 403:
//                   networkExceptions =  const NetworkExceptions.unauthorizedRequest();
//                   break;
//                 case 404:
//                   networkExceptions =  const NetworkExceptions.notFound('Not Found');
//                   break;
//                 case 409:
//                   networkExceptions =  const NetworkExceptions.conflict();
//                   break;
//                 case 408:
//                   networkExceptions =  const NetworkExceptions.requestTimeout();
//                   break;
//                 case 500:
//                   networkExceptions =  const NetworkExceptions.internalServerError();
//                   break;
//                 case 503:
//                   networkExceptions =  const NetworkExceptions.serviceUnavailable();
//                   break;
//                 default:
//                   var responseMessage = error.message;
//                   networkExceptions = NetworkExceptions.defaultError(
//                     responseMessage
//                   );
//               }
//               break;
//           }
//
//         }else if(error is SocketException){
//           networkExceptions =  const NetworkExceptions.noInternetConnection();
//         }else{
//           networkExceptions =  const NetworkExceptions.unexpectedError();
//         }
//         return networkExceptions;
//       } on FormatException catch(_){
//         return const NetworkExceptions.formatException();
//       } catch(_){
//         return const NetworkExceptions.unexpectedError();
//       }
//     }else{
//       if(error.toString().contains('is not a subtype of')){
//         return const NetworkExceptions.unableToProcess();
//       }else{
//         return const NetworkExceptions.unexpectedError();
//       }
//     }
//   }
//
//   static NetworkExceptions getGraphQLError(error){
//     try{
//       NetworkExceptions networkExceptions;
//       if (error is OperationResponse) {
//         networkExceptions = NetworkExceptions.defaultError(error.graphqlErrors!.elementAt(0).message);
//         return networkExceptions;
//       }else{
//         return const NetworkExceptions.unexpectedError();
//       }
//     }catch(error){
//       return NetworkExceptions.defaultError(error.toString());
//     }
//
//   }
//
//   static String getErrorMessage(NetworkExceptions networkExceptions){
//     var errorMessage = '';
//
//     networkExceptions.when(
//         requestCancelled: (){
//           errorMessage = 'Request canceled';
//         },
//         unauthorizedRequest: (){
//           errorMessage = 'Unauthorized request';
//         },
//         badRequest: (){
//           errorMessage = 'Bad request';
//         },
//         notFound: (String reason){
//           errorMessage = reason;
//         },
//         methodNotAllowed: (){
//           errorMessage = 'Method not allowed';
//         },
//         notAcceptable: (){
//           errorMessage = 'Not acceptable';
//         },
//         requestTimeout: (){
//           errorMessage = 'Connection request timeout';
//         },
//         sendTimeout: (){
//           errorMessage = 'Send timeout in connection with API server';
//         },
//         conflict: (){
//           errorMessage = 'Error due to conflict';
//         },
//         internalServerError: (){
//           errorMessage = 'Internal server error';
//         },
//         notImplemented: (){
//           errorMessage = 'Not implemented';
//         },
//         serviceUnavailable: (){
//           errorMessage = 'Server unavailable';
//         },
//         noInternetConnection: (){
//           errorMessage = 'No internet connection';
//         },
//         formatException: (){
//           errorMessage = 'Unexpected error occurred';
//         },
//         unableToProcess: (){
//           errorMessage = 'Unable to process the data';
//         },
//         defaultError: (String error){
//           errorMessage = error;
//         },
//         unexpectedError: (){
//           errorMessage = 'Unexpected error occurred';
//         });
//     return errorMessage;
//   }
// }