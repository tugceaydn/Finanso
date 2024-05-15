import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String?> generateJWT() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return null;
  }

  String token = await _generateToken(user.uid);
  return token;
}

Future<String> _generateToken(String uid) async {
  final jwt = JWT({"user_id": uid});
  String jwtToken = jwt.sign(SecretKey(
      'e026923aa6c691817a810e01a16069c73e7db86f53bdd027ae83a35f4077b551'));
  return jwtToken;
}
