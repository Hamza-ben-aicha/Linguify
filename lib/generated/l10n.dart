// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Linguify`
  String get title {
    return Intl.message(
      'Linguify',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get app_short_description {
    return Intl.message(
      '',
      name: 'app_short_description',
      desc: '',
      args: [],
    );
  }

  /// `*** General worlds ***`
  String get _General {
    return Intl.message(
      '*** General worlds ***',
      name: '_General',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullname {
    return Intl.message(
      'Full Name',
      name: 'fullname',
      desc: '',
      args: [],
    );
  }

  /// `Select Country`
  String get select_country {
    return Intl.message(
      'Select Country',
      name: 'select_country',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confrim_password {
    return Intl.message(
      'Confirm Password',
      name: 'confrim_password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password? `
  String get forget_password {
    return Intl.message(
      'Forgot Password? ',
      name: 'forget_password',
      desc: '',
      args: [],
    );
  }

  /// `*** Splash screen ***`
  String get _SplashScreen {
    return Intl.message(
      '*** Splash screen ***',
      name: '_SplashScreen',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `*** Sign In Screen Translations ***`
  String get _SignInScreen {
    return Intl.message(
      '*** Sign In Screen Translations ***',
      name: '_SignInScreen',
      desc: '',
      args: [],
    );
  }

  /// `Hello again!\nWelcome \nBack`
  String get welcome {
    return Intl.message(
      'Hello again!\nWelcome \nBack',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signin {
    return Intl.message(
      'Sign In',
      name: 'signin',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? `
  String get dont_have_account {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'dont_have_account',
      desc: '',
      args: [],
    );
  }

  /// `*** SignUp Screen ***`
  String get _SignUp_Screen {
    return Intl.message(
      '*** SignUp Screen ***',
      name: '_SignUp_Screen',
      desc: '',
      args: [],
    );
  }

  /// `Hello!\nSignup to\nget started`
  String get gettin_start {
    return Intl.message(
      'Hello!\nSignup to\nget started',
      name: 'gettin_start',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signup {
    return Intl.message(
      'Sign Up',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get already_have_account {
    return Intl.message(
      'Already have an account? ',
      name: 'already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Email already in use`
  String get email_already_in_use {
    return Intl.message(
      'Email already in use',
      name: 'email_already_in_use',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email`
  String get invalid_email {
    return Intl.message(
      'Invalid email',
      name: 'invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `Weak password`
  String get weak_password {
    return Intl.message(
      'Weak password',
      name: 'weak_password',
      desc: '',
      args: [],
    );
  }

  /// `unknown_error`
  String get unknown_error {
    return Intl.message(
      'unknown_error',
      name: 'unknown_error',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwords_do_not_match {
    return Intl.message(
      'Passwords do not match',
      name: 'passwords_do_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Complete Your Account Info\n1/2`
  String get complete_accoun1 {
    return Intl.message(
      'Complete Your Account Info\n1/2',
      name: 'complete_accoun1',
      desc: '',
      args: [],
    );
  }

  /// `Complete Your Account Info\n2/2`
  String get complete_accoun2 {
    return Intl.message(
      'Complete Your Account Info\n2/2',
      name: 'complete_accoun2',
      desc: '',
      args: [],
    );
  }

  /// `Interests`
  String get interests {
    return Intl.message(
      'Interests',
      name: 'interests',
      desc: '',
      args: [],
    );
  }

  /// `Goals`
  String get goals {
    return Intl.message(
      'Goals',
      name: 'goals',
      desc: '',
      args: [],
    );
  }

  /// `Languages you want to learn`
  String get languages_to_learn {
    return Intl.message(
      'Languages you want to learn',
      name: 'languages_to_learn',
      desc: '',
      args: [],
    );
  }

  /// `Your native languages`
  String get native_language {
    return Intl.message(
      'Your native languages',
      name: 'native_language',
      desc: '',
      args: [],
    );
  }

  /// `signup failed`
  String get signup_failed {
    return Intl.message(
      'signup failed',
      name: 'signup_failed',
      desc: '',
      args: [],
    );
  }

  /// `details updated successfully`
  String get details_updated_successfully {
    return Intl.message(
      'details updated successfully',
      name: 'details_updated_successfully',
      desc: '',
      args: [],
    );
  }

  /// `failed to update details`
  String get failed_to_update_details {
    return Intl.message(
      'failed to update details',
      name: 'failed_to_update_details',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
