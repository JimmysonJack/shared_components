import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';

class RoleWidget extends StatelessWidget {
  RoleWidget({super.key});

  final FieldController fieldController = FieldController();

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
        fieldController: fieldController,
        buildContext: context,
        buttonLabel: data != null ? 'Update' : 'Save Role',
        checkUnSavedData: true,
        inputType: 'SaveRoleDtoInput',
        endpointName: 'saveRole',
        inputObjectFieldName: 'roleDto',
        title: data != null ? 'Update Role' : 'Create Role',
        queryFields: 'uid',
        formGroup: FormGroup(
          fieldController: fieldController,
          updateFields: data,
          group: [
            Group(children: [
              fieldController.field.input(
                inputType: 'String',
                widthSize: WidthSize.col12,
                context: context,
                label: 'Role',
                key: 'name',
                validate: true,
                // fieldInputType: FieldInputType
              ),
              fieldController.field.input(
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
        fieldController: fieldController,
        buildContext: context,
        title: 'Set Permission to ${data['name']}',
        formGroup: FormGroup(
          fieldController: fieldController,
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
