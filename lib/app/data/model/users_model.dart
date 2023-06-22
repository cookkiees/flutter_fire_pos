class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  final DateTime? lastSignIn;
  final DateTime? creationTime;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
    this.lastSignIn,
    this.creationTime,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      lastSignIn: json['lastSignIn'] != null
          ? DateTime.tryParse(json['lastSignIn'])
          : null,
      creationTime: json['creationTime'] != null
          ? DateTime.tryParse(json['creationTime'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'lastSignIn': lastSignIn?.toIso8601String(),
      'creationTime': creationTime?.toIso8601String(),
    };
  }
}
