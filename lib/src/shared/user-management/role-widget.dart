import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';

class RoleWidget extends StatelessWidget {
  RoleWidget({super.key, required this.roleConfig});
  final RoleConfig roleConfig;

  final FieldController fieldController = FieldController();

  @override
  Widget build(BuildContext context) {
    return PageableDataTable(
      endPointName: roleConfig.getRolesEndpoint,
      queryFields: roleConfig.getRoleResponseFields,
      mapFunction: roleConfig.mapFunction,
      deleteEndPointName: roleConfig.deleteRoleEndpoint,
      deleteUidFieldName: roleConfig.deleteUIdFieldName,
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
            permissions: ['ROLE_CREATE_ROLE'],
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
        objectInputType: roleConfig.saveRoleInputType,
        endpointName: roleConfig.saveRoleEndpoint,
        inputObjectFieldName: roleConfig.saveRoleInputFieldName,
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
                roleFieldName: roleConfig.roleFieldName,
                roleFieldType: roleConfig.roleFieldType,
                permissionsFieldName: roleConfig.permissionsFieldName,
                permissionsFieldType: roleConfig.permissionsFieldType,
                endPointName: roleConfig.assignPermissionToRoleEndpoint,
                roleUid: data['uid'],
              )
            ])
          ],
        )).show();
  }
}

class RoleConfig {
  final String saveRoleEndpoint;
  final String getRolesEndpoint;
  final String getRoleResponseFields;
  final String getPermissionsEndpoint;
  final String getPermissionsResponseField;
  final String assignPermissionToRoleEndpoint;
  final String deleteRoleEndpoint;
  final Map<String, dynamic> Function(Map<String, dynamic>)? mapFunction;
  final String? deleteUIdFieldName;
  final String saveRoleInputFieldName;
  final String roleFieldName;
  final String roleFieldType;
  final String permissionsFieldName;
  final String permissionsFieldType;
  final String saveRoleInputType;

  RoleConfig(
      {required this.saveRoleEndpoint,
      required this.getRolesEndpoint,
      required this.getRoleResponseFields,
      required this.getPermissionsEndpoint,
      required this.getPermissionsResponseField,
      required this.assignPermissionToRoleEndpoint,
      this.mapFunction,
      this.deleteUIdFieldName,
      required this.saveRoleInputFieldName,
      required this.saveRoleInputType,
      required this.roleFieldName,
      required this.roleFieldType,
      required this.permissionsFieldName,
      required this.permissionsFieldType,
      required this.deleteRoleEndpoint});
}
