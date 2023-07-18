import 'package:flutter/foundation.dart';

class UserProfileItem {
  final Uint8List? image;
  final String userName;
  final String email;
  final Function() onLogout;

  UserProfileItem(
      {this.image,
      required this.onLogout,
      required this.userName,
      required this.email});
}
