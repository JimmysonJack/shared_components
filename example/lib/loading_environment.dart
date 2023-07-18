import 'package:flutter/foundation.dart';
import 'package:shared_component/shared_component.dart';

loadingInvironment(
    {required String devEnvFile, required String prodEnvFile}) async {
  String fileName = kReleaseMode ? prodEnvFile : devEnvFile;
  await dotenv.load(fileName: fileName);
  Environment.getInstance().setClientId(dotenv.env['CLIENT_ID']!);
  Environment.getInstance().setClientSecret(dotenv.env['CLIENT_SECRET']!);
  Environment.getInstance().setServerUrl(dotenv.env['SERVER_URL']!);
}
