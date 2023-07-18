import 'dart:io';

class ConnectionCheck {
  static Future<bool> ping(String address) async {
    try {
      final result = await InternetAddress.lookup(address);

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}
