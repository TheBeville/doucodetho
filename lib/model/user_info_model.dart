class UserInfo {
  final String userID;
  final String username;
  final String? email;
  final bool isLoading;

  UserInfo({
    required this.userID,
    required this.username,
    this.email,
    this.isLoading = false,
  });

  UserInfo copyWith({
    String? userID,
    String? username,
    String? email,
    bool? isLoading,
  }) {
    return UserInfo(
      userID: userID ?? this.userID,
      username: username ?? this.username,
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
