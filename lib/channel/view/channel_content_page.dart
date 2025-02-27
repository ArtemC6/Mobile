import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/channel/cubit/channel_cubit.dart';
import 'package:voccent/channel/widgets/channel_content_widget.dart';
import 'package:voccent/dictionary/cubit/dictionary.dart';
import 'package:voccent/feed/cubit/feed_cubit.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/updater_service/updater_service.dart';

class ChannelContentPage extends StatelessWidget {
  const ChannelContentPage(this._channelId, {super.key});

  final String _channelId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChannelCubit>(
          create: (_) => ChannelCubit(
            context.read<UserScopeClient>(),
            context.read<SharedPreferences>(),
            context.read<UpdaterService>(),
          )
            ..setTab(FeedTab.feed)
            ..fetchChannel(_channelId),
        ),
        BlocProvider(
          create: (context) => FeedCubit(
            context.read<UserScopeClient>(),
            context.read<SharedPreferences>(),
            context.read<HomeCubit>().userLanguages(),
            context.read<HomeCubit>().state.user.currentlang ?? [],
            Dictionary.platformLanguageId(),
          ),
        ),
      ],
      child: const ChannelContentWidget(),
    );
  }
}
