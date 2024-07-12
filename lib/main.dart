import 'package:convocult/generated/l10n.dart';
import 'package:convocult/screens/AccountInfoPage2.dart';
import 'package:convocult/screens/ForgetPasswordPage.dart';
import 'package:convocult/screens/HomePage.dart';
import 'package:convocult/screens/SplashScreen.dart';
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
      locale: const Locale('fr'),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      // home: SplashScreen(),
      home: CompleteAccountPage2(username: "Hamza "),
      routes: {
        '/forgot_password': (context) => ForgotPasswordPage(),
        'home':(context) => HomePage()
      },
    );
  }
}
