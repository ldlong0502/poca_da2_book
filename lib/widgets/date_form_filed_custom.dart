import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/blocs/password_cubit.dart';

import '../utils/convert_utils.dart';
import '../utils/resizable.dart';

class DateFormFieldCustom extends StatefulWidget {
  const DateFormFieldCustom({
    super.key,
    required this.controller,
    required this.title,
    this.focusNode,
    required this.onValidate,
    this.onChanged,
    this.fontSize = 20,
    this.isMaxSize = false,
    this.textColor = Colors.black,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String title;
  final Function onValidate;
  final Function? onChanged;
  final double fontSize;
  final bool isMaxSize;
  final Color textColor;

  @override
  State<DateFormFieldCustom> createState() => _DateFormFieldCustomState();
}

class _DateFormFieldCustomState extends State<DateFormFieldCustom> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900, 1),
        lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
       widget.controller.text = ConvertUtils.convertDob(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _selectDate(context);
      },
      child: IgnorePointer(
        child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            controller: widget.controller,
            obscureText: false,
            validator: (value) {
              return widget.onValidate(value);
            },
            onChanged: widget.onChanged == null
                ? null
                : (value) {
              widget.onChanged!(value);
            },
            focusNode: widget.focusNode,
            style: TextStyle(
                fontSize: Resizable.font(context, widget.fontSize),
                color: widget.textColor,
                fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              fillColor: secondaryColor.withOpacity(0.25),
              filled: true,
              hintText: widget.title,
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: Resizable.font(context, widget.fontSize),
                  color: secondaryColor),
              contentPadding: EdgeInsets.symmetric(
                horizontal: Resizable.padding(context, 20),
                vertical: Resizable.padding(context, 20),
              ),
              constraints: BoxConstraints(
                maxWidth: widget.isMaxSize
                    ? double.infinity
                    : Resizable.width(context) * 0.8,
              ),
              suffixIcon: IconButton(
                onPressed: () {

                },
                icon: const Icon(Icons.calendar_month, color: secondaryColor),
              ),
            )),
      ),
    );
  }
}
