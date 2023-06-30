class LoggedInUserDetails {
  final String? lastLogin;
  final DeviceDetails? loggedInDevice;
  final String? lastLoginLocation;
  final DeviceDetails? authenticatedDevice;
  LoggedInUserDetails(
      {required this.authenticatedDevice,
      required this.lastLogin,
      required this.lastLoginLocation,
      required this.loggedInDevice});
}

class DeviceDetails {
  final String macAddress;
  final String ipAddress;
  final String devicename;
  final String operatingSystem;
  DeviceDetails(
      {required this.devicename,
      required this.ipAddress,
      required this.macAddress,
      required this.operatingSystem});
}

class UserDetails {
  final bool? isLoked;
  final bool? passwordCanExpire;
  final bool? disabled;
  final bool? passwordExpired;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? region;
  final Function(bool) onLocked;
  final Function(bool) onPasswordCanExpire;
  final Function(bool) onDisabled;

  UserDetails(
      {this.isLoked = false,
      this.passwordCanExpire = false,
      this.disabled = false,
      this.passwordExpired = false,
      this.fullName,
      this.email,
      this.phone,
      this.region,
      required this.onDisabled,
      required this.onLocked,
      required this.onPasswordCanExpire});
}
