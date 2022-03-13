class UserData {
  String? uid;
  String? email;
  String? username;

  UserData({this.uid, this.email, this.username});

  // receive data from server
  factory UserData.fromMap(map) {
    return UserData(
        uid: map['uid'],
        email: map['email'],
        username: map['username']
    );
  }

  // send data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
    };
  }
}