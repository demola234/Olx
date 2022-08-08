// ignore_for_file: unused_local_variable

import 'dart:io';
import 'dart:typed_data';
import 'package:ecommerce/core/utils/custom_nav_bar.dart';
import 'package:ecommerce/core/utils/navigator.dart';
import 'package:ecommerce/data/remote/authentication/google_auth_service.dart';
import 'package:ecommerce/features/authentication/presentation/provider/auth_states.dart';
import 'package:flutter/foundation.dart';
import '../../../../di/di.dart';

class GoogleAuthProviders extends ChangeNotifier {
  var googleAuthService = getIt<GoogleAuthServices>();

  GoogleAuthState _googleAuthState = GoogleAuthState.initial;

  GoogleAuthState get googleAuthState => _googleAuthState;

  set googleAuthChange(GoogleAuthState googleAuthServices) {
    _googleAuthState = googleAuthState;
    notifyListeners();
  }

  Future googleAuthentication() async {
    googleAuthChange = GoogleAuthState.loading;
    try {
      final googleAuth = await googleAuthService.googleAuthentication();
      notifyListeners();
      googleAuthChange = GoogleAuthState.success;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future saveDetails(String fullName, File file, String phoneNumber) async {
    googleAuthChange = GoogleAuthState.loading;
    try {
      final saveDetails = await googleAuthService.saveDetails(fullName, file, phoneNumber);
      notifyListeners();
      googleAuthChange = GoogleAuthState.success;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future saveAddress(String address, double latitude, double longitude) async {
    googleAuthChange = GoogleAuthState.loading;
    try {
      final saveAddress = await googleAuthService.saveAddress(address, latitude, longitude);
      notifyListeners();
      googleAuthChange = GoogleAuthState.success;
      NavigationService().replaceScreen(const NavBar());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
