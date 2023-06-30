import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_component/shared_component.dart';

Future<ValueNotifier<GraphQLClient>> graphClient(context) async {
  Api api = Api();
  String? token = await api.userToken(false, context);
  if (token.isEmpty) {
    token = "5b5be6d8-9afd-41bb-88cf-da5aac8e15fb";
  }
  // final HttpLink httpLink = HttpLink('http://192.1.2.10:7100/graphql');
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
