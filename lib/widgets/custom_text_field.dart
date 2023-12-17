import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/blocs/password_cubit.dart';

import '../utils/resizable.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.title,
      this.focusNode,
      required this.onValidate,
      this.prefixIcon,
        this.onChanged,
      this.fontSize = 20,
        this.isMaxSize = false,
        this.textColor = Colors.black,
      required this.isPassword, this.enabled =true});

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String title;
  final Function onValidate;
  final Function? onChanged;
  final bool isPassword;
  final Widget? prefixIcon;
  final double fontSize;
  final bool isMaxSize;
  final Color textColor;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordCubit(),
      child: BlocBuilder<PasswordCubit, bool>(
        builder: (context, state) {
          final cubit = context.read<PasswordCubit>();
          return TextFormField(
              textAlignVertical: TextAlignVertical.center,
              controller: controller,
              enabled: enabled,
              obscureText: isPassword ? !state : false,
              validator: (value) {
                return onValidate(value);
              },
              onChanged: onChanged == null ? null : (value) {
                onChanged!(value);
              },
              focusNode: focusNode,
              style: TextStyle(
                  fontSize: Resizable.font(context, fontSize),
                  color: textColor,
                  fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10)),
                prefixIcon: prefixIcon,
                fillColor: secondaryColor.withOpacity(0.25),
                filled: true,
                hintText: title,
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: Resizable.font(context, fontSize),
                    color: secondaryColor),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 20),
                  vertical: Resizable.padding(context, 20),
                ),
                constraints: BoxConstraints(
                  maxWidth: isMaxSize ? double.infinity : Resizable.width(context) * 0.8 ,
                ),
                suffixIcon: IconButton(
                  onPressed: cubit.update,
                  icon: isPassword
                      ? Icon(
                          !state
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: secondaryColor)
                      : Container(),
                ),
              ));
        },
      ),
    );
  }
}
