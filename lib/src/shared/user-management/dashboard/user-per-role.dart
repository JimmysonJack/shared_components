import 'package:flutter/material.dart';

class UserPerRole extends StatelessWidget {
  const UserPerRole({super.key, required this.roleName, required this.count});
  final String? roleName;
  final String? count;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {},
        leading: const Icon(Icons.task),
        title: Text(roleName?.toUpperCase() ?? ''),
        trailing: Text(
          count ?? '',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
