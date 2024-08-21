import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart' as file;
import '../shared/file_picker/file_picker.dart';
import '../shared/file_picker/file_picker_result.dart';
import '../shared/file_picker/platform_file.dart';
import '../utils/customButton.dart';

class PickFile extends StatefulWidget {
  const PickFile({
    Key? key,
    required this.onFileSelected,
    this.widthByScreenSize = 1,
    this.fileType,
    this.labelText,
  }) : super(key: key);
  final double? widthByScreenSize;
  final String? labelText;
  final void Function(PickerFileData) onFileSelected;
  final FileType? fileType;

  @override
  PickFileState createState() => PickFileState();
}

class PickFileState extends State<PickFile> {
  GlobalKey widgetKey = GlobalKey();
  String? fileName;
  String? fileData;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.6))),
        width: size.width / widget.widthByScreenSize!,
        height: 43,
        child: LayoutBuilder(
          builder: (context, size) {
            return Row(
              children: [
                SizedBox(
                  width: size.biggest.width / 2.4,
                  height: size.biggest.height,
                  child: CustomButton(
                    radius: false,
                    buttonName: widget.labelText ?? 'Attach File',
                    onPressed: () {
                      pickFile();
                    },
                  ),
                ),
                Expanded(
                    child: Center(
                  child: Text(
                    fileName ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ))
              ],
            );
          },
        ),
      ),
    );
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: widget.fileType ?? FileType.any);
    if (result != null) {
      PlatformFile fileData = result.files.first;
      setState(() {
        fileName = fileData.name;
        widget.onFileSelected(PickerFileData(
            fileName: fileName, fileData: base64.encode(fileData.bytes!)));
      });
    }
  }
}

class PickerFileData {
  final String? fileName;
  final String? fileData;

  PickerFileData({this.fileName, this.fileData});
}
