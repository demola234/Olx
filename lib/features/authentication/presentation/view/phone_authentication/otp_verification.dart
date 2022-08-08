import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/image_assets.dart';
import '../../../../../core/utils/config.dart';
import '../../../../../data/remote/authentication/phone_auth_service.dart';
import '../../provider/auth_provider.dart';
import '../../widgets/otp_timer_widget.dart';

class VerifyOTP extends StatefulWidget {
  final String phoneNumber;
  final String verifyId;
  const VerifyOTP({Key? key, required this.phoneNumber, required this.verifyId})
      : super(key: key);

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  PhoneAuthServiceImpl authService = PhoneAuthServiceImpl();
  String? otp;
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 20,
      color: OlxColor.black,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: OlxColor.olxPrimary),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  verifyOTP(BuildContext context) {
      Provider.of<AuthProvider>(context, listen: false)
          .verifyOTP(widget.verifyId, otp!, widget.phoneNumber);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const YMargin(100),
          Container(
            alignment: Alignment.center,
            width: 200,
            height: 66,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(ImagesAsset.olxLogo),
              ),
            ),
          ),
          const YMargin(60),
          Text("Enter the 6 digit OTP", style: Config.h3(context)),
          const YMargin(40.0),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 14,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(widget.phoneNumber, style: Config.b3(context)),
                ),
              ],
            ),
          ),
          const YMargin(8),
          Pinput(
            defaultPinTheme: defaultPinTheme,
            androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
            length: 6,
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            showCursor: true,
            onCompleted: (pin) async {
              setState(() {
                otp = pin;
              });
              verifyOTP(context);
              if (kDebugMode) {
                print(pin);
                print("Entered Otp $pin");
              }
            },
          ),
          const YMargin(10),
          OTPTimerWidget(
            reset: (alert) {
              alert = DateTime.now().add(const Duration(seconds: 90));
            },
          ),
          const YMargin(50),
        ],
      ),
    ));
  }
}
