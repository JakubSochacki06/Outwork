class FirebaseUser {
  String? displayName;
  String? email;
  // String? familyID;
  String? photoURL;
  List<dynamic>? morningRoutines;
  List<dynamic>? nightRoutines;
  List<dynamic>? journalEntries;

  FirebaseUser({this.displayName, this.email, this.photoURL, this.morningRoutines, this.nightRoutines, this.journalEntries});

  factory FirebaseUser.fromMap(Map<String, dynamic> data){
    FirebaseUser user = FirebaseUser(
      displayName: data['displayName'],
      email: data['email'],
      // familyID: data['familyID'],
      photoURL: data['photoURL'],
      morningRoutines: data['morningRoutines'],
      nightRoutines: data['nightRoutines'],
      journalEntries: data['journalEntries'],
    );
    return user;
  }

}