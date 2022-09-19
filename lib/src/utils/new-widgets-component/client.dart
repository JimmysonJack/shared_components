import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../shared_component.dart' hide HiveStore;

 Future<ValueNotifier<GraphQLClient>> graphClient(context)async{
   Api api = Api(context: context);
   print('its =============== being================ called');
   String token = await api.userToken(true);
  final HttpLink httpLink = HttpLink('$serverUrl/graphql');
  final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
  final Link link = authLink.concat(httpLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
          link: link,
          cache: GraphQLCache(store: HiveStore())
      )
  );
  return client;
}