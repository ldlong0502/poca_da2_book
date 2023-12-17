import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:poca/screens/account_screen.dart';
import 'package:poca/screens/home_screen.dart';
import 'package:poca/screens/topic_screen.dart';

class AppCubit extends Cubit<int> {
  AppCubit() : super(0);
  PersistentTabController controller = PersistentTabController(initialIndex: 0);

  int pageSelector = 0;
  Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
  };
  Widget getScreenNow(int index , bool isLogin) {
    switch(index) {
      case 0: return HomeScreen(isLogin: isLogin);
      case 1: return TopicScreen(isLogin: isLogin);
      case 2: return AccountScreen(isLogin: isLogin);
      default: return HomeScreen(isLogin: isLogin);
    }
  }
  updatePage(int index) {
    pageSelector = index;
    emit(state + 1);
  }
}
