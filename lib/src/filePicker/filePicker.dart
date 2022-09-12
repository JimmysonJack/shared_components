import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';

import '../utils/customButton.dart';

class FilePicker extends StatefulWidget {
  const FilePicker(
      {Key? key,
      required this.onFileSelected,
      this.widthByScreenSize = 1,
      this.labelText,
      this.fileType})
      : super(key: key);
  final double? widthByScreenSize;
  final String? labelText;
  final FileTypeCross? fileType;
  final void Function(PickerFileData) onFileSelected;

  @override
  _FilePickerState createState() => _FilePickerState();
}

class _FilePickerState extends State<FilePicker> {
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
                Container(
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
                    style: TextStyle(fontStyle: FontStyle.italic),
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
    FilePickerCross result = await FilePickerCross.importFromStorage(
        type: widget.fileType ?? FileTypeCross.any);
    setState(() {
      fileName = result.fileName;
      widget.onFileSelected(PickerFileData(
          fileName: result.fileName, fileData: result.toBase64()));
    });
    FilePickerCross.delete(path: result.path!);
  }
}

class PickerFileData {
  final String? fileName;
  final String? fileData;

  PickerFileData({this.fileName, this.fileData});
}
