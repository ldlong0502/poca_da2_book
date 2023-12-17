import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:poca/blocs/mini_player_cubit.dart';
import 'package:poca/configs/app_configs.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/blocs/player_cubit.dart';
import 'package:poca/features/blocs/recently_play_cubit.dart';
import 'package:poca/features/blocs/subscribe_cubit.dart';
import 'package:poca/routes/app_routes.dart';
import 'package:poca/services/dynamic_links_service.dart';

import 'features/blocs/user_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  DynamicLinksService.instance.initDynamicLink();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PlayerCubit(context)),
        BlocProvider(create: (context) => UserCubit()),
        BlocProvider(create: (context) => SubscribeCubit()),
        BlocProvider(create: (context) => RecentlyPlayCubit()),
      ],
      child: MaterialApp(
        navigatorObservers: [defaultLifecycleObserver],
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        theme: ThemeData(
          textTheme: Theme
              .of(context)
              .textTheme
              .apply(
            fontSizeFactor: 1.0,
            fontFamily: "Montserrat",
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent, // Đặt màu sắc cho AppBar ở đây
          ),
        ),

        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.splash,
      ),
    );
  }
}


