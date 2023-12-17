import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:poca/routes/app_routes.dart';

class NavigatorCustom {
  static void pushNewScreen(BuildContext context, Widget screen , String routes) {
    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
      context,
      screen: screen,
      withNavBar: true,
      pageTransitionAnimation:
      PageTransitionAnimation.cupertino,
      settings:  RouteSettings(name: routes),
    );

  }
}