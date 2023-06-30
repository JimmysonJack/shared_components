import 'package:flutter/material.dart';
import 'package:shared_component/src/shared/user-management/details-card.dart';

import '../../components/button.dart';
import '../../utils/size_config.dart';
import 'helper-classes.dart';
import 'user-list-widget.dart';

class UserManager extends StatefulWidget {
  const UserManager({super.key});

  @override
  State<UserManager> createState() => _UserManagerState();
}

class _UserManagerState extends State<UserManager>
    with SingleTickerProviderStateMixin {
  double width = 0;
  double height = SizeConfig.fullScreen.height;
  bool showDetails = true;
  bool shakeIt = false;
  Map<String, dynamic> userData = {};
  bool locked = true;
  bool active = true;
  bool credentialCanExpire = true;
  @override
  void initState() {
    width = SizeConfig.fullScreen.width * 0.5;
    // _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
            child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 1000),
          crossFadeState: !showDetails
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: UserListWidget(onTap: (Map<String, dynamic> data) {
            setState(() {
              showDetails = !showDetails;
              shakeIt = true;

              if (!showDetails) {
                width = 0;
              } else {
                width = SizeConfig.fullScreen.width * 0.5;
              }
            });
            Future.delayed(const Duration(milliseconds: 200), () {
              setState(() {
                shakeIt = false;
                userData = data;
                locked = userData['enabled'];
                active = userData['isActive'];
                credentialCanExpire = userData['credentialsNonExpired'];
              });
            });
          }),
          secondChild: Container(
            height: height,
            color: Colors.blueGrey,
            child: Center(
              child: Button(
                  labelText: 'Press',
                  onPressed: () {
                    setState(() {
                      showDetails = !showDetails;
                      if (!showDetails) {
                        width = 0;
                      } else {
                        width = SizeConfig.fullScreen.width * 0.5;
                      }
                    });
                  }),
            ),
          ),
        )),
        DetailCard(
          loggedInUserDetails: LoggedInUserDetails(
            lastLogin: userData['lastLogin'],
            authenticatedDevice: null,
            lastLoginLocation: null,
            loggedInDevice: null,
          ),
          userDetails: UserDetails(
              passwordCanExpire: !credentialCanExpire,
              email: userData['email'],
              fullName: userData['name'],
              onDisabled: (value) {},
              onLocked: (value) {},
              onPasswordCanExpire: (value) {},
              phone: userData['phoneNumber'],
              region: userData['facility']?['name'],
              disabled: !active,
              isLoked: !locked),
          userUid: userData['uid'] ?? '',
          height: height,
          width: width,
          showDetails: showDetails,
          shakeIt: shakeIt,
          onEditUser: (data) {},
        )
      ],
    );
  }
}
