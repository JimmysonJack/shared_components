import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'file_picker_io.dart';

// ignore: import_of_legacy_library_into_null_safe

/// Implementation of file selection dialog using file_picker for mobile platforms
Future<Map<String, Uint8List>> selectFilesMobile({
  required FileTypeCross type,
  required String fileExtension,
}) async {
  final filePickerResults = await FilePicker.platform.pickFiles(
      type: fileTypeCrossParse(type),
      allowedExtensions: parseExtension(fileExtension));

  final p = filePickerResults?.files.single.path;

  File file = File(p!);

  return {file.path: await file.readAsBytes()};
}

/// Implementation of file selection dialog for multiple files using file_picker for mobile platforms
Future<Map<String, Uint8List>> selectMultipleFilesMobile({
  required FileTypeCross type,
  required String fileExtension,
}) async {
  final files = await FilePicker.platform.pickFiles(
      type: fileTypeCrossParse(type),
      allowMultiple: true,
      allowedExtensions: parseExtension(fileExtension));

  // FilePickerResult files = f!;

  Map<String, Uint8List> filesMap = {};
  if (files is FilePickerResult) {
    for (var path in files.paths) {
      filesMap[path!] = File(path).readAsBytesSync();
    }
  }

  return filesMap;
}

Future<String> saveFileMobile({
  required FileTypeCross type,
  required String fileExtension,
}) async {
  /// TODO: implement
  throw UnimplementedError('Unsupported Platform for file_picker_cross');
}
