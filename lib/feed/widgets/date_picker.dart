import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:intl/intl.dart';
import 'package:voccent/feed/cubit/feed_cubit.dart';
import 'package:voccent/generated/l10n.dart';

class DatePicker extends StatelessWidget {
  DatePicker({
    required this.isStartDate,
    required this.callback,
    super.key,
  });

  final DateTime selectedDate = DateTime.now();
  final void Function(DateTime) callback;
  final bool isStartDate;

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      callback(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    if (isStartDate) {
      return Center(
        child: InkWell(
          onTap: () => _selectDate(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (context.read<FeedCubit>().state.period ==
                        FeedPeriodFilter.customPeriod &&
                    context.read<FeedCubit>().state.customPeriodFrom !=
                        null) ...[
                  FxText.bodyLarge(
                    DateFormat.yMd().format(
                      context.read<FeedCubit>().state.customPeriodFrom!,
                    ),
                    color: mTheme.onPrimary,
                  ),
                ] else ...[
                  FxText.bodyLarge(
                    S.current.filterSelectDate,
                    color: mTheme.onPrimary,
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }
    return Center(
      child: InkWell(
        onTap: () => _selectDate(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (context.read<FeedCubit>().state.period ==
                      FeedPeriodFilter.customPeriod &&
                  context.read<FeedCubit>().state.customPeriodTo != null) ...[
                FxText.bodyLarge(
                  DateFormat.yMd().format(
                    context.read<FeedCubit>().state.customPeriodTo!,
                  ),
                  color: mTheme.onPrimary,
                ),
              ] else ...[
                FxText.bodyLarge(
                  S.current.filterSelectDate,
                  color: mTheme.onPrimary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
