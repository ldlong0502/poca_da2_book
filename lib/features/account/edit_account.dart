import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/account/playlist/base_bottom_sheet.dart';
import 'package:poca/features/blocs/user_cubit.dart';
import 'package:poca/models/playlist.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/providers/api/api_playlist.dart';
import 'package:poca/providers/api/api_user.dart';
import 'package:poca/screens/playlist_detail_screen.dart';
import 'package:poca/screens/playlist_screen.dart';
import 'package:poca/services/cloud_service.dart';
import 'package:poca/utils/custom_toast.dart';
import 'package:poca/widgets/custom_button.dart';
import 'package:poca/widgets/loading_progress.dart';
import 'package:poca/widgets/network_image_custom.dart';

import '../../../models/episode.dart';
import '../../../utils/resizable.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/date_form_filed_custom.dart';

class EditAccount extends StatelessWidget {
  const EditAccount({super.key});


  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    return BaseBottomSheet(
      child: BlocProvider(
        create: (context) =>
        EditAccountCubit(userCubit.state!)
          ..load(),
        child: BlocBuilder<EditAccountCubit, int>(
          builder: (context, state) {
            final editCubit = context.read<EditAccountCubit>();
            final userCubit = context.read<UserCubit>();
            return SizedBox(
              height: Resizable.height(context) * 0.95,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              )),
                          Text(
                            'Edit Profile',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: Resizable.font(context, 25)),
                          ),
                          TextButton(
                              onPressed: () async {
                                if (editCubit.isCreating) {
                                  CustomToast.showBottomToast(
                                      context, 'Wait for updating');
                                  return;
                                }
                                if (editCubit.fullNameController.text.isEmpty) {
                                  CustomToast.showBottomToast(
                                      context, 'Name cannot empty');
                                  return;
                                }
                                var url = '';
                                if (editCubit.image != null) {
                                  url = await CloudService.instance.uploadImage(
                                      File(editCubit.image!.path),
                                      DateTime
                                          .now()
                                          .millisecondsSinceEpoch
                                          .toString());
                                }
                                var newUrl = url.isEmpty ? editCubit.userModel
                                    .imageUrl : url;
                                if (editCubit.fullNameController.text ==
                                    editCubit.userModel.fullName &&
                                    editCubit.userModel.imageUrl == newUrl &&
                                    editCubit.dobController.text ==
                                        DateFormat('dd-MM-yyyy').format(
                                            editCubit.userModel.dateOfBirth)
                                ) {
                                  if(context.mounted) {
                                    Navigator.pop(context);
                                    CustomToast.showBottomToast(context, 'Nothing change');
                                    return;
                                  }
                                }
                                var newModel = editCubit.userModel.copyWith(
                                  fullName: editCubit.fullNameController.text,
                                  imageUrl: newUrl,
                                  dateOfBirth: DateFormat("dd-MM-yyyy").parse(editCubit.dobController.text)
                                );

                                editCubit.updateCreate(true);

                                final res = await ApiUser.instance.updateUser(newModel.id, newModel.toJson());

                                if(res) {
                                  userCubit.update(newModel);
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    editCubit.updateCreate(false);
                                    CustomToast.showBottomToast(context, 'Updated Successfully');
                                  }
                                }
                                else {
                                  if (context.mounted) {
                                    editCubit.updateCreate(false);
                                    CustomToast.showBottomToast(context, 'Something error');
                                  }
                                }


                              },
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    editCubit.image == null ? NetworkImageCustom(
                      url: editCubit.userModel.imageUrl,
                      borderRadius: BorderRadius.circular(1000),
                      width: Resizable.size(context, 220),
                      height: Resizable.size(context, 220),
                    ) : Container(
                      width: Resizable.size(context, 220),
                      height: Resizable.size(context, 220),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          image: editCubit.image == null
                              ? null
                              : DecorationImage(
                              image: FileImage(File(editCubit.image!.path)),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(1000)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                          debugPrint(image!.path);
                          await editCubit.update(image);
                        },
                        child: const Text(
                          'Change photo',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        )),
                    SizedBox(
                      width: Resizable.width(context) * 0.8,
                      child: TextFormField(
                        controller: editCubit.fullNameController,
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 20)
                      ),
                      child: const Text(
                        'This could be your full name or a nickname. It\'s how you\'ll appear on Poca.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    InkWell(
                      onTap: () {
                        CustomToast.showBottomToast(
                            context, 'Can\'t edit email');
                      },
                      child: IgnorePointer(
                        child: CustomTextField(
                            controller: editCubit.emailController,
                            title: 'Email',
                            enabled: false,
                            textColor: Colors.white,
                            onValidate: (String value) {
                              debugPrint('validate: $value');
                              if (value.isEmpty) {
                                return 'Username is empty';
                              }
                              return null;
                            },
                            isPassword: false),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    DateFormFieldCustom(
                      controller: editCubit.dobController,
                      title: 'Date of Birth',
                      textColor: Colors.white,
                      onValidate: (String value) {
                        if (value.isEmpty) {
                          return 'Dob is empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (editCubit.isCreating)
                      const LoadingProgress(
                        color: Colors.white,
                      ),
                    const SizedBox(
                      height: 10,
                    ),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class EditAccountCubit extends Cubit<int> {
  EditAccountCubit(this.userModel) : super(0);
  final UserModel userModel;
  XFile? image;
  TextEditingController userNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isCreating = false;

  load() {
    userNameController.text = userModel.username;
    fullNameController.text = userModel.fullName;
    emailController.text = userModel.email;
    dobController.text = DateFormat('dd-MM-yyyy').format(userModel.dateOfBirth);
    emit(state + 1);
  }

  update(XFile? img) {
    image = img;
    emit(state + 1);
  }

  updateCreate(bool value) {
    isCreating = value;
    emit(state + 1);
  }

}