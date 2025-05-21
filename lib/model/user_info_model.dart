class UserInfo {
  final String userID;
  final String username;
  final String? email;

  UserInfo({
    required this.userID,
    required this.username,
    this.email,
  });
}
