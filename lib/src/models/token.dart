class Token {
  String? accessToken;
  String? tokenType;
  String? refreshToken;
  int? expiresIn;
  DateTime? expiresAt;
  String? scope;
  Token(
      {this.accessToken,
      this.tokenType,
      this.refreshToken,
      this.expiresIn,
      this.expiresAt,
      this.scope});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'access_token': accessToken,
      'token_type': tokenType,
      'refresh_token': refreshToken,
      'expires_in': expiresIn,
      'expires_at': expiresAt.toString(),
      'scope': scope
    };
  }

  factory Token.fromJson(Map<String, dynamic> json) {
    DateTime expiresAt;
    if (json['expires_at'] == null) {
      if (json['expires_in'] != null) {
        expiresAt =
            DateTime.now().add(Duration(seconds: json['expires_in'] as int));
      } else {
        expiresAt = DateTime.now();
      }
    } else {
      expiresAt = DateTime.parse(json['expires_at']);
    }
    return Token(
        accessToken: json['access_token'] as String?,
        tokenType: json['token_type'] as String?,
        refreshToken: json['refresh_token'] as String?,
        expiresIn: json['expires_in'] as int?,
        expiresAt: expiresAt,
        scope: json['scope'] as String?);
  }

  @override
  String toString() {
    String time = expiresAt.toString();
    return '{access_token:"$accessToken", token_type:"$tokenType", refresh_token:"$refreshToken", expires_in:$expiresIn, expires_at:"$time"}';
  }
}
