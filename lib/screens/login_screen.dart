import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:poca/features/blocs/login_cubit.dart';
import 'package:poca/providers/api/api_auth.dart';
import 'package:poca/utils/custom_toast.dart';
import 'package:poca/widgets/custom_text_field.dart';

import '../configs/constants.dart';
import '../features/dialogs/login_dialog.dart';
import '../routes/app_routes.dart';
import '../utils/resizable.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final  _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => LoginCubit(),
            child: BlocConsumer<LoginCubit, LoginStatus>(
              listener: (context, state)  async {
                if (state == LoginStatus.loading) {
                  await showDialog<void>(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return const LoadingDialog();
                    },
                  );
                }
                if (state == LoginStatus.failed) {
                 if(context.mounted) {
                   Navigator.pop(context);
                   await showDialog<void>(
                     context: context,
                     builder: (BuildContext dialogContext) {
                       return const LoginErrorDialog();
                     },
                   );
                 }
                }
                if (state == LoginStatus.success) {
                  CustomToast.showBottomToast(context, 'Welcome to Poca');
                  Navigator.of(context, rootNavigator: true)
                      .pushNamedAndRemoveUntil(AppRoutes.splash, (route) => false);
                }
              },
              builder: (context, state) {
                final cubit = context.read<LoginCubit>();
                return Column(
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
                    Form(
                      key: _formKey,
                        child: Column(
                      children: [
                        CustomTextField(
                            controller: userNameController,
                            title: 'Username',
                            onValidate: (String value) {
                              debugPrint('validate: $value');
                              if(value.isEmpty) {
                                return 'Username is empty';
                              }
                              return null;
                            },
                            isPassword: false),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                            controller: passWordController,
                            title: 'Password',
                            onValidate: (String value) {
                              if(value.isEmpty) {
                                return 'Password is empty';
                              }
                              return null;
                            },
                            isPassword: true),
                      ],
                    )),
                    SizedBox(
                      width: Resizable.width(context) * 0.8,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            CustomToast.showBottomToast(context, 'Welcome to Poca');
                          },
                          style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero)),
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                                color: secondaryColor,
                                fontSize: Resizable.font(context, 15),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                        title: 'Sign In',
                        onTap: () async {
                          final isValid = _formKey.currentState!.validate();
                          if (!isValid) {
                            return;
                          }
                          _formKey.currentState!.save();
                          cubit.update(LoginStatus.loading);
                          var res = await ApiAuthentication.instance.login(
                              userNameController.text, passWordController.text);
                          if (res) {
                            cubit.update(LoginStatus.success);
                          } else {
                            cubit.update(LoginStatus.failed);
                          }
                        },
                        width: Resizable.width(context) * 0.8,
                        backgroundColor: primaryColor,
                        textColor: Colors.white),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have account?',
                          style: TextStyle(
                              color: secondaryColor,
                              fontSize: Resizable.font(context, 15),
                              fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).popAndPushNamed(AppRoutes.signUp);
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: Resizable.font(context, 16),
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
