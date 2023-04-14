import 'dart:io';

import 'package:flutter/foundation.dart';

import 'console.dart';

class ConnectionCheck {
  static Future<bool> ping(String address) async {
    try {
      final result = await InternetAddress.lookup(address);

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        console(result);
        return true;
      } else {
        console(result);
        return false;
      }
    } catch (error) {
      console(error);
      return false;
    }
  }
}
