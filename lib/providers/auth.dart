import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userEmail;
  bool hasMadeCall = false;

  Future _loadToken() async {
    final pref = await SharedPreferences.getInstance();
    _token = pref.getString('token');
    notifyListeners();
    print('loaded token $_token\n');
  }

  Future _loadEmail() async {
    final pref = await SharedPreferences.getInstance();
    _userEmail = pref.getString('userEmail');
    print('loading email $_userEmail \n');
    notifyListeners();
  }

  Future<bool> get isAuth async {
    await _loadToken();
    return _token != null;
  }

  Future<String?> get userEmail async {
    await _loadEmail();
    return _userEmail;
  }

  void setToken(String token, String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print('Set token $token');
    print('setting $_userEmail \n');
    await pref.setString('token', token);
    await pref.setString('userEmail', email);
  }

  Future<void> deleteToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('token');
    pref.remove('userEmail');
    _token = null;
    _userEmail = null;
    notifyListeners();
    print('Removed token');
  }
}
