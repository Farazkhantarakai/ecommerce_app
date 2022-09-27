import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/Models/http_exceptions.dart';

class Authentication with ChangeNotifier {
  String? _tokenId; //these are necessary
  DateTime? _expiryData;
  String? _userId;
  bool get auth {
    return token != '';
  }

//if we have _tokenId and _expireData and all of these are not null
  String get token {
    if (_tokenId != null &&
        _expiryData != null &&
        _expiryData!.isAfter(DateTime.now())) {
      return _tokenId.toString();
    }
    return '';
  }

  Future<void> authentication(urlSegment, email, password) async {
    String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAWV-GqFeAtzbaDtxw2wU02gJIiDlxfBiE';
    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        _tokenId = result['idToken'];
        // print(_tokenId);
        _expiryData = DateTime.now()
            .add(Duration(seconds: int.parse(result['expiresIn'])));
        // print(_expiryData);
        _userId = result['localId'];

        //try to not use log because of some issue
        if (kDebugMode) {
          print(result['error']);
        }

        if (result['error'] != null) {
          throw HttpException(result['error']['message']);
        }
        //we do all of these stuff for the purpose of getting the token
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  // signUp
  Future<void> signUp(email, password) async {
    String _urlSegment = 'signUp';
    return authentication(_urlSegment, email, password);
    // String url =
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAWV-GqFeAtzbaDtxw2wU02gJIiDlxfBiE';
    // final response = await http.post(Uri.parse(url),
    //     body: jsonEncode(
    //         {'email': email, 'password': password, 'returnSecureToken': true}));

    // print(jsonDecode(response.body));
  }

// signInWithPassword
  Future<void> signIn(email, password) async {
    String _urlSegment = 'signInWithPassword';
    return authentication(_urlSegment, email, password);
    // String url =
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAWV-GqFeAtzbaDtxw2wU02gJIiDlxfBiE';
    // final response = await http.post(Uri.parse(url),
    //     body: jsonEncode(
    //         {'email': email, 'password': password, 'returnSecureToken': true}));
    // print(jsonDecode(response.body));
  }
}
