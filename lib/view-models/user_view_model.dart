import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lingo_hands/models/user.dart';
import 'package:lingo_hands/services/user_services.dart';

class UserViewModel extends ChangeNotifier {
  final UserServices _userServices;
  final _storage = const FlutterSecureStorage();

  UserViewModel({
    required UserServices userServices,
  }) : _userServices = userServices;

  Future<void> loadCurrentUser() async {
    final userJson = await _storage.read(key: 'user');
    if (userJson != null) {
      _userServices.setCurrentUser(User.fromJson(jsonDecode(userJson)));
    }
    notifyListeners();
  }

  Future<void> setCurrentUser(User user) async {
    _userServices.setCurrentUser(user);
    await _storage.write(key: 'user', value: user.toJson());
    notifyListeners();
  }

  Future<User?> getCurrentUser() async {
    final userJson = await _storage.read(key: 'user');
    if (userJson != null) {
      _userServices.setCurrentUser(User.fromJson(jsonDecode(userJson)));
    }
    return _userServices.getCurrentUser();
  }

  Future<void> clearCurrentUser() async {
    _userServices.clearCurrentUser();
    await _storage.delete(key: 'user');
    notifyListeners();
  }

  Role getUserRole() {
    return _userServices.getUserRole();
  }

  SignLanguageType getUserSignLanguageType() {
    return _userServices.getUserSignLanguageType();
  }

  String getUserName() {
    return _userServices.getUserName();
  }

  bool isUserDeaf() {
    return _userServices.isUserDeaf();
  }

  bool isUserHearing() {
    return _userServices.isUserHearing();
  }
}