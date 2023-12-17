import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:poca/features/blocs/login_cubit.dart';
import 'package:poca/providers/api/api_auth.dart';
import 'package:poca/utils/convert_utils.dart';
import 'package:poca/utils/custom_toast.dart';
import 'package:poca/widgets/custom_text_field.dart';
import 'package:poca/widgets/date_form_filed_custom.dart';

import '../configs/constants.dart';
import '../features/blocs/sign_up_cubit.dart';
import '../routes/app_routes.dart';
import '../utils/resizable.dart';
import '../widgets/custom_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController(text: ConvertUtils.convertDob(DateTime.now()));
  final  _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..backgroundColor = primaryColor;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: primaryColor),
        automaticallyImplyLeading: false,
        title: const Text('Sign up' , style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => SignUpCubit(),
            child: BlocConsumer<SignUpCubit, SignUpStatus>(
              listener: (context, state) {
                if (state == SignUpStatus.loading) {
                  EasyLoading.show(status: 'Loading...');
                }
                if (state == SignUpStatus.failed) {
                  EasyLoading.dismiss();
                  CustomToast.showBottomToast(
                      context, 'Email or Username is existed');
                }
                if (state == SignUpStatus.success) {
                  EasyLoading.dismiss();
                  CustomToast.showBottomToast(context, 'Sign up successfully');
                  Navigator.of(context, rootNavigator: true)
                      .popAndPushNamed(AppRoutes.login);
                }
              },
              builder: (context, state) {
                final cubit = context.read<SignUpCubit>();
                return Column(
                  children: [

                    Image.asset('assets/icons/ic_logo.png',
                        height: Resizable.size(context, 100)),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                                controller: emailController,
                                title: 'Email Address',
                                onValidate: (String value) {
                                  debugPrint('validate: $value');
                                  if(value.isEmpty) {
                                    return 'Email is empty';
                                  }
                                  return null;
                                },
                                isPassword: false),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                                controller: fullNameController,
                                title: 'FullName',
                                onValidate: (String value) {
                                  debugPrint('validate: $value');
                                  if(value.isEmpty) {
                                    return 'FulName is empty';
                                  }
                                  return null;
                                },
                                isPassword: false),
                            const SizedBox(
                              height: 20,
                            ),
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
                            DateFormFieldCustom(
                                controller: dobController,
                                title: 'Date of Birth',
                                onValidate: (String value) {
                                  if(value.isEmpty) {
                                    return 'Dob is empty';
                                  }
                                  return null;
                                },
                                ),
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

                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                        title: 'Sign Up',
                        onTap: () async {
                          final isValid = _formKey.currentState!.validate();
                          if (!isValid) {
                            return;
                          }
                          _formKey.currentState!.save();
                          cubit.update(SignUpStatus.loading);
                          var res = await ApiAuthentication.instance.signUp(
                                emailController.text,
                            fullNameController.text,
                            userNameController.text,
                            dobController.text,
                            passWordController.text
                          );
                          if (res) {
                            cubit.update(SignUpStatus.success);
                          } else {
                            cubit.update(SignUpStatus.failed);
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
                          'Already have an account?',
                          style: TextStyle(
                              color: secondaryColor,
                              fontSize: Resizable.font(context, 15),
                              fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).popAndPushNamed(AppRoutes.login);
                          },
                          child: Text(
                            'Sign In',
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
