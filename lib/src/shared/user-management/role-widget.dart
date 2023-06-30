import 'package:flutter/material.dart';

import '../../utils/table.dart';
import '../form-group.dart';
import '../list_data_table.dart';
import '../paginated_data_table.dart';
import '../permissions-widget/permission-set.dart';
import '../pop-up-model.dart';
import '../text-inputs.dart';

class RoleWidget extends StatelessWidget {
  const RoleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PageableDataTable(
      endPointName: 'getRoles',
      queryFields: "name description uid",
      // mapFunction: (item) => {'userName': item['name']},
      deleteEndPointName: 'deleteRole',
      // deleteUidFieldName: 'userUid',
      actionButtons: [
        ActionButtonItem(
            icon: Icons.check_box,
            name: 'Set Permission',
            onPressed: (value) {
              setPermissions(context, value);
            }),
        ActionButtonItem(
            icon: Icons.edit_document,
            name: 'Edit Role',
            onPressed: (value) {
              saveAndUpdateRole(context, value);
            }),
      ],
      tableAddButton: TableAddButton(
          onPressed: () {
            saveAndUpdateRole(context, null);
          },
          buttonName: 'Create Role'),
      topActivityButtons: [
        TopActivityButton(
            onTap: () {
              saveAndUpdateRole(context, null);
            },
            buttonName: 'Create Role',
            // iconData: Icons.create,
            toolTip: 'Adding new Role'),
      ],
      headColumns: [
        HeadTitleItem(
          titleKey: 'name',
          titleName: 'Role Name',
        ),
        HeadTitleItem(
          titleKey: 'description',
          titleName: 'Description',
        ),
      ],
    );
  }

  saveAndUpdateRole(context, data) {
    PopupModel(
        buildContext: context,
        buttonLabel: data != null ? 'Update' : 'Save Role',
        checkUnSavedData: true,
        inputType: 'SaveRoleDtoInput',
        endpointName: 'saveRole',
        inputObjectFieldName: 'roleDto',
        title: data != null ? 'Update Role' : 'Create Role',
        queryFields: 'uid',
        formGroup: FormGroup(
          updateFields: data,
          group: [
            Group(children: [
              Field.use.input(
                context: context,
                label: 'Role',
                key: 'name',
                validate: true,
                // fieldInputType: FieldInputType
              ),
              Field.use.input(
                context: context,
                label: 'Description',
                key: 'description',
                validate: true,
                // fieldInputType: FieldInputType
              ),
            ])
          ],
        )).show();
  }

  setPermissions(context, data) {
    PopupModel(
        buildContext: context,
        title: 'Set Permission to ${data['name']}',
        formGroup: FormGroup(
          group: [
            Group(children: [
              PermissionSettings(
                endPointName: 'savePermissions',
                roleUid: data['uid'],
              )
            ])
          ],
        )).show();
  }
}
