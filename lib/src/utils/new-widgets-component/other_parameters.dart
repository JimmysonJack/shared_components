class OtherParameters {
  final String keyName;
  final String keyValue;
  final String keyType;

  OtherParameters(
      {required this.keyName, required this.keyValue, required this.keyType});

  Map<String, dynamic> toMap() {
    return {
      'keyName': keyName,
      'keyValue': keyValue,
      'keyType': keyType,
    };
  }

  factory OtherParameters.fromMap(Map<String, dynamic> map) {
    return OtherParameters(
      keyName: map['keyName'] as String,
      keyValue: map['keyValue'] as String,
      keyType: map['keyType'] as String,
    );
  }
}
