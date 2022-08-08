import 'package:ecommerce/core/constants/colors.dart';
import 'package:ecommerce/core/constants/image_assets.dart';
import 'package:ecommerce/core/utils/navigator.dart';
import 'package:ecommerce/features/authentication/presentation/provider/google_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/config.dart';
import '../../../../../core/utils/custom_buttons.dart';
import '../phone_authentication/phone_screen.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {"text": "Welcome to Olx, Let’s shop!", "image": ImagesAsset.olxShop},
    {
      "text": "We help people connect with store \naround Nigeria",
      "image": ImagesAsset.olxShopping
    },
    {
      "text": "We show the easy way to shop. \nJust stay at home with us",
      "image": ImagesAsset.olxCart
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              const YMargin(20),
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
              Expanded(
                flex: 3,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index) => SplashContent(
                    image: splashData[index]["image"]!,
                    text: splashData[index]['text']!,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: <Widget>[
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          splashData.length,
                          (index) => buildDot(index: index),
                        ),
                      ),
                      const Spacer(flex: 3),
                      OlxButton(
                        color: OlxColor.olxPrimary,
                        onTap: () {
                          NavigationService().navigateToScreen(const EnterPhone());
                        },
                        text: "Continue with Phone",
                        icon: ImagesAsset.phone,
                      ),
                      const YMargin(15),
                      OlxButton(
                        color: Colors.white,
                        textColor: const Color(0xFF212F20),
                        onTap: () => googleAuthentication(context),
                        text: "Continue with Google",
                        icon: ImagesAsset.google,
                        isBorder: true,
                      ),
                      const YMargin(15),
                      OlxButton(
                        color: const Color(0xFF4267B2),
                        onTap: () {},
                        text: "Continue with Facebook",
                        icon: ImagesAsset.fb,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  googleAuthentication(BuildContext context) {
    Provider.of<GoogleAuthProviders>(context, listen: false)
        .googleAuthentication();
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? OlxColor.olxPrimary : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    required this.text,
    required this.image,
  }) : super(key: key);
  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Lottie.asset(
          image,
          height: 320,
          width: 320,
          animate: true,
          repeat: false,
        ),
        const Spacer(flex: 2),
        Text(
          text,
          style: Config.b1(context).copyWith(),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
      ],
    );
  }
}
