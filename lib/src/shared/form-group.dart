import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shared_component/shared_component.dart';

ValueNotifier<dynamic> notifierValue = ValueNotifier('');

class FormGroup extends StatefulWidget {
  const FormGroup(
      {super.key,
      required this.fieldController,
      this.group,
      this.updateFields});
  final List<Group>? group;
  final Map<String, dynamic>? updateFields;
  final FieldController fieldController;

  @override
  State<FormGroup> createState() => _FormGroupState();
}

class _FormGroupState extends State<FormGroup> {
  List<Map<String, dynamic>>? convertedUpdatedFields = [];
  @override
  void initState() {
    widget.updateFields == null ? convertedUpdatedFields = null : null;
    List<Map<String, dynamic>> tempDataList = [];
    if (widget.updateFields != null) {
      for (var i = 0; i < widget.updateFields!.keys.length; i++) {
        if (widget.updateFields?.keys.toList()[i] != '__typename') {
          tempDataList.add({
            widget.updateFields!.keys.toList()[i]:
                widget.updateFields!.values.toList()[i]
          });
        }
      }
    }
    convertedUpdatedFields =
        tempDataList.isEmpty ? null : tempDataList.map((e) => e).toList();

    widget.fieldController.updateFieldList = List.generate(
        convertedUpdatedFields?.length ?? 0,
        (index) => {
              '${convertedUpdatedFields?[index].keys.first}_':
                  convertedUpdatedFields?[index].values.first
            });
    if (convertedUpdatedFields != null) {
      widget.fieldController.field.setUpdateFields(convertedUpdatedFields);

      widget.fieldController.updateFieldList = List.generate(
          widget.fieldController.updateFieldList.length,
          (index) => {
                widget.fieldController.updateFieldList[index].keys.first
                        .replaceAll('_', ''):
                    widget.fieldController.updateFieldList[index].values.first
              });
      checkForInputsEquality();
      notifierValue.addListener(() {
        checkForInputsEquality();
      });
    } else {
      checkForInputsEquality();
      notifierValue.addListener(() {
        checkForInputsEquality();
      });
    }
    super.initState();
  }

  checkForInputsEquality() {
    var dataToBeUpdated = convertedUpdatedFields ??
        widget.fieldController.field.fieldValuesController.instanceValues
            .map((e) => e)
            .toList();
    if (widget.fieldController.updateFieldList.every((el) => dataToBeUpdated
            .any((e) => e[el.keys.first] == el[el.keys.first])) &&
        widget.fieldController.updateFieldList.isNotEmpty) {
      widget.fieldController.field.updateState = true;
    } else if (widget.fieldController.updateFieldList.isNotEmpty ||
        dataToBeUpdated.isNotEmpty) {
      widget.fieldController.field.updateState = false;
    } else {
      widget.fieldController.field.updateState = true;
    }
  }

  @override
  void dispose() {
    widget.fieldController.clearFields();
    // notifierValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!widget.fieldController.field.updateState &&
              widget.fieldController.updateFieldList.isNotEmpty)
            Container(
                color: ThemeController.getInstance().darkMode(
                    darkColor: const Color.fromARGB(255, 14, 146, 146),
                    lightColor: const Color.fromARGB(255, 101, 223, 186)),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(5),
                child: const Text(
                  'Changes Detected',
                  style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
                )),
          ...widget.group!
        ],
      );
    });
  }
}

class Group extends StatelessWidget {
  const Group({Key? key, this.header, required this.children})
      : super(key: key);
  final String? header;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 20),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null)
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 2),
                  child: Text(
                    header!,
                    style: TextStyle(
                        fontSize: 10, color: Theme.of(context).hintColor),
                  ),
                )),
          if (header == null)
            const SizedBox(
              height: 10,
            ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Wrap(
              runSpacing: 10,
              alignment: WrapAlignment.spaceBetween,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
