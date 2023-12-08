class FirebaseUser {
  String? displayName;
  String? email;
  // String? familyID;
  String? photoURL;

  FirebaseUser({this.displayName, this.email, this.photoURL});

  factory FirebaseUser.fromMap(Map<String, dynamic> data){
    FirebaseUser user = FirebaseUser(
      displayName: data['displayName'],
      email: data['email'],
      // familyID: data['familyID'],
      photoURL: data['photoURL'],
    );
    return user;
  }

}