import 'package:flutter/material.dart';
import 'package:shared_component/shared_component.dart';

RegExp regex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{1,8}$');

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});
  // TextInput textInput = TextInput();
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController verifyPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: SizeConfig.screenHeight * 0.3,
        width: SizeConfig.screenHeight * 0.3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Change Password',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              hintText: 'Current Password',
              controller: currentPassword,
              validator: (value) {
                if (isInputNull(value) || value!.isEmpty) {
                  return 'Old Password must be provided';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              hintText: 'New Password',
              controller: currentPassword,
              validator: (value) {
                if (!regex.hasMatch(value!)) {
                  return 'New Password must be provided';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              hintText: 'Confirm Password',
              controller: currentPassword,
              validator: (value) {
                if (newPassword.text != value) {
                  return 'Error! Does not match';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            GElevatedButton('Change Password', onPressed: () {})
          ],
        ),
      ),
    );
  }
}
