import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shared_component/shared_component.dart';

ValueNotifier<dynamic> notifierValue = ValueNotifier('');

class FormGroup extends StatefulWidget {
  const FormGroup({super.key, this.group, this.updateFields});
  final List<Group>? group;
  final Map<String, dynamic>? updateFields;

  @override
  State<FormGroup> createState() => _FormGroupState();
}

class _FormGroupState extends State<FormGroup> {
  List<Map<String, dynamic>>? convertedUpdatedFields = [];
  @override
  void initState() {
    widget.updateFields == null ? convertedUpdatedFields = null : null;
    if (widget.updateFields != null) {
      for (var i = 0; i < widget.updateFields!.keys.length; i++) {
        if (widget.updateFields?.keys.toList()[i] != '__typename') {
          convertedUpdatedFields?.add({
            widget.updateFields!.keys.toList()[i]:
                widget.updateFields!.values.toList()[i]
          });
        }
      }
    }
    Field.updateFieldList = List.generate(
        convertedUpdatedFields?.length ?? 0,
        (index) => {
              '${convertedUpdatedFields?[index].keys.first}_':
                  convertedUpdatedFields?[index].values.first
            });
    if (convertedUpdatedFields != null) {
      Field.use.setUpdateFields(convertedUpdatedFields);
      Field.updateFieldList = List.generate(
          Field.updateFieldList.length,
          (index) => {
                Field.updateFieldList[index].keys.first.replaceAll('_', ''):
                    Field.updateFieldList[index].values.first
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
    var dataToBeUpdated =
        convertedUpdatedFields ?? FieldValues.getInstance().instanceValues;
    if (Field.updateFieldList.every((el) => dataToBeUpdated
            .any((e) => e[el.keys.first] == el[el.keys.first])) &&
        Field.updateFieldList.isNotEmpty) {
      Field.use.updateState = true;
    } else {
      if (Field.updateFieldList.isNotEmpty) {
        Field.use.updateState = false;
      } else if (dataToBeUpdated.isNotEmpty) {
        Field.use.updateState = false;
      } else {
        Field.use.updateState = true;
      }
    }
  }

  @override
  void dispose() {
    Field.clearFields();
    // notifierValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!Field.use.updateState && Field.updateFieldList.isNotEmpty)
            Container(
                color: const Color(0xffA8FFC6),
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
      color: Theme.of(context).secondaryHeaderColor,
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
