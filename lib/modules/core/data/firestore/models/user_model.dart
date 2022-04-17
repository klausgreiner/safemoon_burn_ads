class User {
  final String name;
  final String password;
  final int score;

  User({required this.name, required this.password, required this.score});

  Map<String, dynamic> toMap() {
    return {'name': name, 'password': password, 'score': score};
  }

  User.fromFirestore(Map<String, dynamic> firestore)
      : name = firestore['name'],
        password = firestore['password'],
        score = firestore['score'];
}
