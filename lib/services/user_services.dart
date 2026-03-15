import 'package:lingo_hands/models/user.dart';

class UserServices {
  User? _currentUser;

  UserServices({
    User? currentUser,
  }) : _currentUser = currentUser;

  void setCurrentUser(User user) {
    _currentUser = user;
  }

  User? getCurrentUser() {
    return _currentUser;
  }

  void clearCurrentUser() {
    _currentUser = null;
  }

  Role getUserRole() {
    return _currentUser!.role;
  }

  SignLanguageType getUserSignLanguageType() {
    return _currentUser!.signLanguageType;
  }

  String getUserName() {
    return _currentUser!.name;
  }

  bool isUserDeaf() {
    return _currentUser!.role == Role.deaf;
  }

  bool isUserHearing() {
    return _currentUser!.role == Role.hearing;
  }
}