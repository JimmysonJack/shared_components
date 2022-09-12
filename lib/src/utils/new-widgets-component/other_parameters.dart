class OtherParameters{
  final String keyName;
  final String keyValue;

  OtherParameters({required this.keyName, required this.keyValue,});

  Map<String, dynamic> toMap() {
    return {
      'keyName': keyName,
      'keyValue': keyValue,
    };
  }

  factory OtherParameters.fromMap(Map<String, dynamic> map) {
    return OtherParameters(
      keyName: map['keyName'] as String,
      keyValue: map['keyValue'] as String,
    );
  }
}