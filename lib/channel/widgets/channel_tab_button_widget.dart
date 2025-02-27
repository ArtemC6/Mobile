import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:voccent/channel/cubit/channel_cubit.dart';
import 'package:voccent/feed/cubit/feed_cubit.dart';

class ChannelTabButtonWidget extends StatelessWidget {
  const ChannelTabButtonWidget({
    required this.tab,
    required this.isActive,
    required this.text,
    required this.color,
    required this.borderColor,
    super.key,
  });

  final FeedTab tab;
  final bool isActive;
  final String text;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
        border: isActive
            ? Border.all(
                color: borderColor,
                width: 2,
              )
            : null,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 44 : 40,
      child: InkWell(
        onTap: () => context.read<ChannelCubit>().setTab(tab),
        child: Center(
          child: FxText.bodyMedium(
            text,
            fontWeight: 700,
            fontSize: 12,
            color: const Color.fromARGB(255, 70, 70, 70),
          ),
        ),
      ),
    );
  }
}
