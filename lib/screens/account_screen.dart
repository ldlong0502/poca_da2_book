import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/account/edit_account.dart';
import 'package:poca/features/account/none_account_view.dart';
import 'package:poca/features/blocs/user_cubit.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/routes/app_routes.dart';
import 'package:poca/screens/base_screen.dart';
import 'package:poca/screens/playlist_screen.dart';
import 'package:poca/utils/dialogs.dart';
import 'package:poca/utils/navigator_custom.dart';
import 'package:poca/utils/resizable.dart';
import 'package:poca/widgets/custom_button.dart';

import '../configs/constants.dart';
import '../providers/api/api_auth.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key, required this.isLogin});

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    var mapItems = [
      {
        'title': 'Account',
        'showIcon': false,
        'onClick': () {
          Dialogs.showBottomSheet(context, const EditAccount());
        },
      },
      {
        'title': 'Your library',
        'showIcon': true,
        'onClick': () {},
      },
      {
        'title': 'Playlist',
        'showIcon': true,
        'onClick': () {
          print('++++++++ click');
          NavigatorCustom.pushNewScreen(context, const PlaylistScreen(), AppRoutes.playlist);
        },
      },
      {
        'title': 'Audio Quality',
        'showIcon': true,
        'onClick': () {},
      },
      {
        'title': 'Storage',
        'showIcon': true,
        'onClick': () {},
      },
      {
        'title': 'Private & Social',
        'showIcon': true,
        'onClick': () {},
      },
      {
        'title': 'Terms & Conditions',
        'showIcon': true,
        'onClick': () {},
      },
      {
        'title': 'Change Password',
        'showIcon': true,
        'onClick': () {},
      },
      {
        'title': 'About',
        'showIcon': true,
        'onClick': () {},
      },
    ];
    return BaseScreen(
      title: 'Account',
      child: SingleChildScrollView(
        child: BlocBuilder<UserCubit, UserModel?>(
          builder: (context, state) {
            if(state == null) return const NoneAccountView();
            return  Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      ...mapItems.map((e) {
                        return GestureDetector(
                          onTap: e['onClick'] as Function(),
                          child: SizedBox(
                            height: Resizable.size(context, 45),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                      e['title'] as String,
                                      style: TextStyle(
                                          fontSize: Resizable.font(context, 20),
                                          color: textColor,
                                          fontWeight: FontWeight.w600),
                                    )),
                                SizedBox(
                                  width: Resizable.size(context, 50),
                                  child: !(e['showIcon'] as bool)
                                      ? null
                                      : IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: secondaryColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 20,),
                      CustomButton(title: 'Log out',
                          onTap: () {
                            ApiAuthentication.instance.logOut(context);
                          },
                          backgroundColor: primaryColor,
                          textColor: Colors.white),

                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
