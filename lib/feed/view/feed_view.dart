import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/feed/cubit/feed_cubit.dart';
import 'package:voccent/feed/widgets/feed_widget.dart';
import 'package:voccent/home/cubit/home_cubit.dart';

class FeedView extends StatelessWidget {
  const FeedView({this.parameters, super.key});

  final Parameters? parameters;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FeedCubit(
        context.read<UserScopeClient>(),
        context.read<SharedPreferences>(),
        context.read<HomeCubit>().userLanguages(),
        context.read<HomeCubit>().state.user.currentlang ?? [],
        Dictionary.platformLanguageId(),
      )
        ..setTab(parameters?.tab ?? FeedTab.feed)
        ..setCategoryFilter(parameters?.category ?? ''),
      child: const FeedWidget(),
    );
  }
}

class Parameters {
  Parameters({
    this.category,
    this.tab,
  });
  String? category;
  FeedTab? tab;
}
