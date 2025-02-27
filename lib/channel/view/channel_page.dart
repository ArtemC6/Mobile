import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/channel/cubit/channel_cubit.dart';
import 'package:voccent/channel/widgets/channel_widget.dart';
import 'package:voccent/feed/cubit/feed_cubit.dart';
import 'package:voccent/updater_service/updater_service.dart';

class ChannelPage extends StatelessWidget {
  const ChannelPage({this.channelId, this.channelName, super.key});

  final String? channelId;
  final String? channelName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChannelCubit>(
      create: (_) {
        final c = ChannelCubit(
          context.read<UserScopeClient>(),
          context.read<SharedPreferences>(),
          context.read<UpdaterService>(),
        )..setTab(FeedTab.feed);

        if (channelId != null) {
          c.fetchChannel(channelId!);
        } else if (channelName != null) {
          c.fetchChannelByName(channelName!);
        }

        return c;
      },
      child: const ChannelWidget(),
    );
  }
}
