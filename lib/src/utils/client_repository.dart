import 'dart:convert';

import 'package:ferry/ferry.dart';
// import 'package:ferry/typed_links.dart';
import 'package:ferry_hive_store/ferry_hive_store.dart';
import 'package:flutter/widgets.dart';
import 'package:gql_http_link/gql_http_link.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_component/shared_component.dart';

class ClientRepository {
  static Future<Client> initClient()async{
    BuildContext? cxt;
    Api api = Api(context: cxt);

    await Hive.initFlutter();

    final box = await Hive.openBox('graphql');

    final store = HiveStore(box);

    final cache = Cache(store: store);

    // String? token = await api.userToken(true);

    final link = HttpLink('$serverUrl/graphql',defaultHeaders: {
      // "authorization": 'Bearer $token',
      "authorization": 'Bearer f19fb4aa-7b9f-48fc-a729-114c63b505e1',
    });

    final client = Client(link: link,cache: cache);

    return client;
  }
}