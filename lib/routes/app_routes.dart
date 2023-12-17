import 'package:flutter/material.dart';
import 'package:poca/models/audio_book.dart';
import 'package:poca/screens/home_screen.dart';
import 'package:poca/screens/login_screen.dart';
import 'package:poca/screens/main_screen.dart';
import 'package:poca/screens/on_board_screen.dart';
import 'package:poca/screens/sign_up_screen.dart';

import '../screens/audio_book_detail_screen.dart';
import '../screens/splash_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const main = '/main';
  static const audioBookDetail = '/audioBookDetail';
  static const onBoarding = '/onBoarding';
  static const login = '/login';
  static const signUp = '/signUp';
  static const topicDetail = '/topicDetail';
  static const podcastDetail = '/podcastDetail';
  static const playlist = '/playlist';
  static const playlistDetail = '/playlistDetail';
  static const subsSeeAll = '/subsSeeAll';
  static const recentlySeeAll = '/recentlySeeAll';
  static const editAccount = '/editAccount';

  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
            builder: (context) => const SplashScreen(), settings: settings);
      case AppRoutes.main:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => MainScreen(isLogin: map['isLogin']),
            settings: settings);
      case AppRoutes.audioBookDetail:
        final map = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (context) => AudioBookDetailScreen(audioBook: map['audioBook']),
            settings: settings);
      case AppRoutes.onBoarding:
        return MaterialPageRoute(
            builder: (context) => const OnBoardingScreen(),
            settings: settings);
      case AppRoutes.login:
        return MaterialPageRoute(
            builder: (context) => const LoginScreen(),
            settings: settings);
      case AppRoutes.signUp:
        return MaterialPageRoute(
            builder: (context) => const SignUpScreen(),
            settings: settings);
    }

    return null;
  }
}
