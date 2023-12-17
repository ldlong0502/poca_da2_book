import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:poca/blocs/app_cubit.dart';
import 'package:poca/blocs/mini_player_cubit.dart';
import 'package:poca/configs/app_configs.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/blocs/player_cubit.dart';
import 'package:poca/screens/explore_screen.dart';
import 'package:lifecycle/lifecycle.dart';
import '../utils/resizable.dart';
import '../widgets/custom_mini_player.dart';
import 'account_screen.dart';
import 'home_screen.dart';
import 'topic_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.isLogin});

  final bool isLogin;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with  LifecycleAware, LifecycleMixin {
  @override
  void onLifecycleEvent(LifecycleEvent event) async {
    if(event == LifecycleEvent.push || event == LifecycleEvent.visible || event == LifecycleEvent.active) {
      debugPrint('actice');
    }
    else {
      if(context.mounted){
        context.read<PlayerCubit>().pause();
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    AppConfigs.contextApp = context;
    var child = [
      HomeScreen(isLogin: widget.isLogin),
      TopicScreen(isLogin: widget.isLogin),
      const ExploreScreen(),
      AccountScreen(isLogin: widget.isLogin)
    ];

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon:  Image.asset('assets/icons/ic_home_fill.png' , color: purpleColor,),
          inactiveIcon:  Image.asset('assets/icons/ic_home.png' , color: purpleColor,),
          title: ('Home'),
          activeColorPrimary: purpleColor,
          inactiveColorPrimary: purpleColor,
        ),
        PersistentBottomNavBarItem(
          icon:  Image.asset('assets/icons/ic_structure_fill.png' , color: purpleColor,),
          inactiveIcon:  Image.asset('assets/icons/ic_structure.png' , color: purpleColor,),
          title: ("Topics"),
          activeColorPrimary: purpleColor,
          inactiveColorPrimary: purpleColor,
        ),
        PersistentBottomNavBarItem(
          icon:  Image.asset('assets/icons/ic_search_fill.png' , color: purpleColor,),
          inactiveIcon:  Image.asset('assets/icons/ic_search.png' , color: purpleColor,),
          title: ("Explore"),
          activeColorPrimary: purpleColor,
          inactiveColorPrimary: purpleColor,
        ),
        PersistentBottomNavBarItem(
          icon:  Image.asset('assets/icons/ic_setting_fill.png' , color: purpleColor,),
          inactiveIcon:  Image.asset('assets/icons/ic_setting.png' , color: purpleColor,),
          title: ("Settings"),
          activeColorPrimary: purpleColor,
          inactiveColorPrimary: purpleColor,
        ),
      ];
    }
    return Scaffold(
      body: BlocBuilder<PlayerCubit, int>(
        builder: (context, state) {
          final cubit = context.read<PlayerCubit>();

          return Scaffold(
            body: Stack(
              children: [
                PersistentTabView(
                  context,
                  screens: child,
                  controller: cubit.persistentTabController,
                  hideNavigationBar: !cubit.isMiniPlayer || cubit.isHideBottomNavigator,
                  items: navBarsItems(),
                  confineInSafeArea: true,
                  backgroundColor: Colors.white,
                  handleAndroidBackButtonPress: true,
                  resizeToAvoidBottomInset: true,
                  stateManagement: true,
                  hideNavigationBarWhenKeyboardShows: true,
                  decoration: NavBarDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15)
                    ),
                    colorBehindNavBar: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  popAllScreensOnTapOfSelectedTab: true,
                  popActionScreens: PopActionScreensType.all,
                  itemAnimationProperties: const ItemAnimationProperties(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.ease,
                  ),
                  screenTransitionAnimation: const ScreenTransitionAnimation(
                    animateTabTransition: true,
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 200),
                  ),
                  navBarStyle: NavBarStyle
                      .style9, // Choose the nav bar style with this property.
                ),
                const CustomMiniPlayer()
              ],
            ),
          );
        },
      ),

    );
  }
}
