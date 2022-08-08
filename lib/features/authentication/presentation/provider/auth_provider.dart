import 'dart:io';
import 'dart:typed_data';
import 'package:ecommerce/features/authentication/presentation/provider/auth_states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/custom_toasts.dart';
import '../../../../core/utils/navigator.dart';
import '../../../../data/remote/authentication/phone_auth_service.dart';
import '../../../../di/di.dart';
import '../view/phone_authentication/otp_verification.dart';

class AuthProvider extends ChangeNotifier {
  var authService = getIt<PhoneAuthService>();
  String verificationId = '';

  PhoneAuthState _phoneAuthState = PhoneAuthState.initial;

  PhoneAuthState get phoneAuthState => _phoneAuthState;

  set phoneAuthStateChange(PhoneAuthState phoneAuthState) {
    _phoneAuthState = phoneAuthState;
    notifyListeners();
  }

  TextEditingController phoneTextEditingController = TextEditingController();

  Future<void> verifyPhoneNumber(String number) async {
    await authService.verifyPhoneNumber(number, failed: (error) {
      phoneAuthStateChange = PhoneAuthState.error;
      Toasts.showErrorToast(error.toString());
    }, completed: (credential) async {
      if (credential.smsCode != null && credential.verificationId != null) {
        verificationId = credential.verificationId!;
        notifyListeners();
        Toasts.showSuccessToast("OTP Sent");
        await verifyOTP(
            credential.verificationId!, credential.smsCode!, number);
      }
    }, codeAutoRetrievalTimeout: (id) {
      verificationId = id;
      notifyListeners();
      phoneAuthStateChange = PhoneAuthState.codeSent;
    }, codeSent: (String id, int? token) {
      verificationId = id;
      NavigationService().replaceScreen(
          VerifyOTP(phoneNumber: number, verifyId: verificationId));
      notifyListeners();
      Toasts.showSuccessToast("OTP Sent");

      phoneAuthStateChange = PhoneAuthState.codeSent;
    });
  }

  Future verifyOTP(String verificationId, String otp, String phone) async {
    phoneAuthStateChange = PhoneAuthState.loading;
    try {
      await authService.phoneCredential(verificationId, otp, phone);
      notifyListeners();
      phoneAuthStateChange = PhoneAuthState.success;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future saveDetails(String fullName, String email, File file) async {
    phoneAuthStateChange = PhoneAuthState.loading;
    try {
       await authService.saveDetails(fullName, email, file);
      notifyListeners();
      phoneAuthStateChange = PhoneAuthState.success;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
