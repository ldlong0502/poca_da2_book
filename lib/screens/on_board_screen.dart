import 'package:flutter/material.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/providers/preference_provider.dart';
import 'package:poca/routes/app_routes.dart';
import 'package:poca/utils/resizable.dart';
import 'package:poca/widgets/custom_button.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  updateOnBoarding() async {
    await PreferenceProvider.instance.setString('on_boarding', 'true');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                'assets/icons/ic_bg_circle_1.png',
                width: Resizable.width(context) / 2,
                fit: BoxFit.fill,
                height: Resizable.height(context) * 4 / 9,
              )),
          Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'assets/icons/ic_bg_circle_2.png',
                width: Resizable.width(context) / 2,
                fit: BoxFit.fill,
                height: Resizable.height(context) * 3 / 4,
              )),
          SizedBox(
            height: Resizable.height(context),
            width: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      'assets/icons/ic_bg.png',
                      height: Resizable.size(context, 150),
                    ),
                    Image.asset('assets/icons/ic_logo.png',
                        height: Resizable.size(context, 100)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Text(
                        'A digital audio file made available on the internet for downloading to a mobile device, typically available as a series, new installments of which can be received by subscribers automatically.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: Resizable.font(context, 16),
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    CustomButton(
                        title: 'Sign Up',
                        onTap: () async {
                          await updateOnBoarding();
                          if (context.mounted) {
                            Navigator.pushNamed(context, AppRoutes.signUp);
                          }
                        },
                        backgroundColor: secondaryColor,
                        textColor: Colors.white),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                        title: 'Sign In',
                        onTap: () async {
                          await updateOnBoarding();
                          if (context.mounted) {
                            Navigator.pushNamed(context, AppRoutes.login);
                          }
                        },
                        backgroundColor: primaryColor,
                        textColor: Colors.white),
                    const SizedBox(
                      height: 5,
                    ),
                    TextButton(
                      onPressed: () async {
                        await updateOnBoarding();
                        if (context.mounted) {
                          Navigator.popAndPushNamed(context, AppRoutes.splash);
                        }
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Resizable.font(context, 22),
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
