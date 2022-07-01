import 'dart:convert';

import 'package:ferry/ferry.dart';
// import 'package:ferry/typed_links.dart';
import 'package:ferry_hive_store/ferry_hive_store.dart';
import 'package:gql_http_link/gql_http_link.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_component/shared_component.dart';

class ClientRepository {
  static Future<Client> initClient()async{

    await Hive.initFlutter();

    final box = await Hive.openBox('graphql');

    final store = HiveStore(box);

    final cache = Cache(store: store);

    Map<String,dynamic> tokenRaw = jsonDecode(await StorageService.getString('user_token') ?? '');

    String? token = tokenRaw['access_token'];

    final link = HttpLink('$serverUrl/graphql',defaultHeaders: {
      // "authorization": 'Bearer f1cfd361-c295-41c5-9b64-5e98cbeeb35d',
      "authorization": 'Bearer $token',
    });

    final client = Client(link: link,cache: cache);

    return client;
  }
}