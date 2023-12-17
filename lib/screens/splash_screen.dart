import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/blocs/player_cubit.dart';
import 'package:poca/features/blocs/user_cubit.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/providers/preference_provider.dart';
import 'package:poca/providers/user/user_provider.dart';
import 'package:poca/routes/app_routes.dart';
import 'package:poca/utils/resizable.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    applicationInit(context);
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/icons/ic_logo.png',
          height: Resizable.size(context, 200),
          width: Resizable.size(context, 200),
        ),
      ),
    );
  }

  void applicationInit(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var user = await PreferenceProvider.instance.getJsonFromPrefs("user");
    String onBoarding = await PreferenceProvider.instance.getString("on_boarding");
    if(onBoarding.isEmpty) {
      if(context.mounted) {
        Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
            AppRoutes.onBoarding, (route) => false);
      }
    } else {
      if(context.mounted) {
        context.read<PlayerCubit>().dismissMiniPlayer();
      }
      if(user == null) {
        if (context.mounted) {
          context.read<UserCubit>().update(null);
          Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
              AppRoutes.main, (route) => false,
              arguments: {'isLogin': false});
        }
      }
      else {
        var model = UserModel.fromJson(user);
        UserProvider.instance.setUser(model);
        if (context.mounted) {
          context.read<UserCubit>().update(model);
          Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
              AppRoutes.main, (route) => false,
              arguments: {'isLogin': true});
        }
      }

    }

  }
}
