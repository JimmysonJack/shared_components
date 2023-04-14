import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shared_component/shared_component.dart';

ValueNotifier<dynamic> notifierValue = ValueNotifier('');

class FormGroup extends StatefulWidget {
  FormGroup({Key? key, this.group, this.updateFields}) : super(key: key) {
    Field.updateFieldList = List.generate(
        updateFields?.length ?? 0,
        (index) => {
              '${updateFields?[index].keys.first}_':
                  updateFields?[index].values.first
            });
  }
  final List<Group>? group;
  final List<Map<String, dynamic>>? updateFields;

  @override
  State<FormGroup> createState() => _FormGroupState();
}

class _FormGroupState extends State<FormGroup> {
  @override
  void initState() {
    if (widget.updateFields != null) {
      Field.use.setUpdateFields(widget.updateFields);
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
        widget.updateFields ?? FieldValues.getInstance().instanceValues;
    if (Field.updateFieldList.every((el) =>
        dataToBeUpdated.any((e) => e[el.keys.first] == el[el.keys.first])) && Field.updateFieldList.isNotEmpty) {
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
          if(header == null) const SizedBox(height: 10,),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Wrap(
              runSpacing: 10,
              alignment: WrapAlignment.spaceBetween,
              children: List.generate(children.length,
                  (wrapIndex) => children.elementAt(wrapIndex)),
            ),
          ),
        ],
      ),
    );
  }
}
