class UserProfile {
  String id;
  String username;

  UserProfile({required this.id, required this.username});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(id: json['id'], username: json['username']);
  }
}
