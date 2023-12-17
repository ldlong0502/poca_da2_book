import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/player_cubit.dart';

class BaseBottomSheet extends StatefulWidget {
  const BaseBottomSheet({super.key, required this.child});
  final Widget child;
  @override
  State<BaseBottomSheet> createState() => _BaseBottomSheetState();
}

class _BaseBottomSheetState extends State<BaseBottomSheet>  {
  @override
  void initState() {
    context.read<PlayerCubit>().updateHideBottomNavigator(true);
    super.initState();

    debugPrint('aloooo');
  }
  @override
  void deactivate() {
    context.read<PlayerCubit>().updateHideBottomNavigator(false);
    super.deactivate();

    debugPrint('aaaa');
  }
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
