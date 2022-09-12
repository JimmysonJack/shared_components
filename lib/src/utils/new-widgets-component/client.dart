import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

 ValueNotifier<GraphQLClient> graphClient(){
  final HttpLink httpLink = HttpLink('https://janju.herokuapp.com/graphql');
  final AuthLink authLink = AuthLink(getToken: () async => 'Bearer f28ff526-4a60-4b29-9d78-5a2565c52df3');
  final Link link = authLink.concat(httpLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
          link: link,
          cache: GraphQLCache(store: HiveStore())
      )
  );
  return client;
}