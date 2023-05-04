import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_component/shared_component.dart';

Future<ValueNotifier<GraphQLClient>> graphClient(context) async {
  Api api = Api();
  String? token = await api.userToken(false, context);
  if (token.isEmpty) {
    token = "4eda7571-c14d-4ce7-b7db-d3a9401fee2c";
  }
  final HttpLink httpLink =
      HttpLink('${Environment.getInstance().getServerUrl()}/graphql');
  console(Environment.getInstance().getServerUrl());
  final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
  console(authLink);
  final Link link = authLink.concat(httpLink);
  console(link);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(link: link, cache: GraphQLCache(store: HiveStore())));
  console('this is the client...........$client');
  return client;
}
