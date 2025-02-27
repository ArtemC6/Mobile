import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/widgets/widgets.dart';
import 'package:voccent/classroom_search/cubit/classroom_search_cubit.dart';
import 'package:voccent/classroom_search/widgets/search_classroom.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/home_cubit.dart';

class ClassroomPage extends StatefulWidget {
  const ClassroomPage({super.key});

  @override
  State<ClassroomPage> createState() => _ClassroomPageState();
}

class _ClassroomPageState extends State<ClassroomPage>
    with SingleTickerProviderStateMixin {
  final filterQueryEdtCnt = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    filterQueryEdtCnt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final user = state.user;
        if (state.user.id == null) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        } else {
          return BlocConsumer<ClassroomSearchCubit, ClassroomSearchState>(
            listenWhen: (previous, current) =>
                current.searchClassromPages[0]?.isLoading == false,
            listener: (context, state) {
              /// actual if click reset/clear
              // if (state.query == '' &&
              //     filterQueryEdtCnt.text != state.query) {
              //   filterQueryEdtCnt.clear();
              // }
            },
            builder: (context, state) {
              final mTheme = Theme.of(context).colorScheme;

              return DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        FeatherIcons.chevronLeft,
                        size: 25,
                        color: mTheme.onBackground,
                      ),
                    ),
                    centerTitle: true,
                    title: FxText.titleMedium(
                      S.current.classroomSearchClassroom.toUpperCase(),
                      fontWeight: 700,
                      textScaleFactor: 1.2257,
                      color: mTheme.primary,
                    ),
                  ),
                  body: SearchClassroom(
                    filterQueryEdtCnt: filterQueryEdtCnt,
                    user: user,
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
