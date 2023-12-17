import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/blocs/explore_cubit.dart';
import 'package:poca/features/explores/item_search.dart';
import 'package:poca/features/explores/search_field.dart';
import 'package:poca/screens/base_screen.dart';
import 'package:poca/widgets/custom_text_field.dart';
import 'package:poca/widgets/loading_progress.dart';

import '../utils/resizable.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final textController = TextEditingController();
  final  focusNode = FocusNode();


  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExploreCubit(),
      child: BlocBuilder<ExploreCubit, int>(
        builder: (context, state) {
          if (state == 0) return const LoadingProgress();
          final cubit = context.read<ExploreCubit>();
          focusNode.addListener(() {
            if (focusNode.hasFocus) {
               cubit.updateFocus(true);
            } else {
              cubit.updateFocus(false);
            }
          });
          return BaseScreen(
            title: 'Explore',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: CustomTextField(
                            controller: textController,
                            title: 'What do you want to listen to?',
                            onValidate: (value) {
                              return null;
                            },
                            fontSize: 16,
                            focusNode: focusNode,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: secondaryColor,
                            ),
                            onChanged: (value) {
                              cubit.searchPodcasts(value);
                            },
                            isMaxSize: true,
                            isPassword: false),
                      ),
                      if (cubit.isFocus)
                        TextButton(onPressed: () {
                          focusNode.unfocus();
                        }, child: const Text('Cancel'))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Builder(
                    builder: (context) {
                      var text = cubit.isSearching ? 'Search for "${textController.text}"' : "Recent searches";
                      return Text(text, style: TextStyle(
                          fontSize: Resizable.font(context, 24),
                          color: textColor,
                          fontWeight: FontWeight.w600
                      ),);
                    }
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    shrinkWrap: true,
                    children: [
                      ...cubit.listPodcast.map((e) {
                        return ItemSearch(isHistory: !cubit.isSearching, podcast: e);
                      }).toList(),
                      const SizedBox(height: 200,)
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
