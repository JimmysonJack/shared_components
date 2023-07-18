import 'dart:convert';

// import 'package:dhms/app/config/languages/sw.dart';
//
// import '../service/storage_service.dart';
import 'package:shared_component/src/languages/sw.dart';

import '../service/storage_service.dart';
import 'en.dart';

class Intl {
  static String trans(String word, String lang) {
    Map<String, dynamic> words = lang == 'en'
        ? jsonDecode(en) as Map<String, dynamic>
        : jsonDecode(sw) as Map<String, dynamic>;
    String translated = words[word] ?? word;
    return translated;
  }

  static Future<String> lang() async {
    return await StorageService.getString('lang') ?? 'en';
  }
}
