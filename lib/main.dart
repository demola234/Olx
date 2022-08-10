import 'dart:async';
import 'package:ecommerce/core/constants/colors.dart';
import 'package:ecommerce/core/constants/image_assets.dart';
import 'package:ecommerce/features/authentication/presentation/provider/google_provider.dart';
import 'package:ecommerce/features/save_product/presentation/provider/save_product_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nested/nested.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'core/utils/custom_nav_bar.dart';
import 'core/utils/navigator.dart';
import 'di/di.dart';
import 'features/add_product/presentation/provider/categories_provider.dart';
import 'features/authentication/presentation/provider/auth_provider.dart';
import 'features/authentication/presentation/view/onboarding/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await injector();
  Provider.debugCheckInvalidValueType = null;
  runApp(MultiProvider(providers: providers, child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        if (event == null) {
          NavigationService().replaceScreen(const OnBoarding());
        } else {
          NavigationService().replaceScreen(const NavBar());
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: MaterialApp(
      title: 'Olx',
      navigatorKey: NavigationService().navigationKey,
      debugShowCheckedModeBanner: false,
      home: const Splash(),
    ));
  }
}

List<SingleChildWidget> get providers {
  return [
    ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider(),
    ),
    ChangeNotifierProvider<GoogleAuthProviders>.value(
      value: GoogleAuthProviders(),
    ),
    ChangeNotifierProvider<CategoriesProvider>.value(
      value: CategoriesProvider(),
    ),
    ChangeNotifierProvider<SaveProductProvider>.value(
      value: SaveProductProvider(),
    ),
  ];
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OlxColor.olxPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SafeArea(
        child: Center(
          child: SvgPicture.asset(ImagesAsset.logo),
        ),
      ),
    );
  }
}
