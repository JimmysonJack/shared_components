import 'package:flutter/foundation.dart';

console(dynamic log) {
  if (kDebugMode) {
    print(log);
  }
}

bool callOnce = true;
