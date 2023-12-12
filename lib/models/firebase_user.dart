class FirebaseUser {
  String? displayName;
  String? email;
  // String? familyID;
  String? photoURL;
  List<String>? morningRoutines;

  FirebaseUser({this.displayName, this.email, this.photoURL, this.morningRoutines});

  factory FirebaseUser.fromMap(Map<String, dynamic> data){
    FirebaseUser user = FirebaseUser(
      displayName: data['displayName'],
      email: data['email'],
      // familyID: data['familyID'],
      photoURL: data['photoURL'],
      morningRoutines: data['morningRoutines'],
    );
    return user;
  }

}