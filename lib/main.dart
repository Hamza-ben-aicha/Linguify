import 'package:Linguify/generated/l10n.dart';
import 'package:Linguify/screens/AccountInfoPage2.dart';
import 'package:Linguify/screens/ForgetPasswordPage.dart';
import 'package:Linguify/screens/HomePage.dart';
import 'package:Linguify/screens/LoginPage.dart';
import 'package:Linguify/screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en'),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: SplashScreen(),
      // home: CompleteAccountPage2(username: "Hamza "),
      routes: {
        '/forgot_password': (context) => ForgotPasswordPage(),
        '/home':(context) => HomePage(),
        '/login':(context) => Loginpage()
      },
    );
  }
}
