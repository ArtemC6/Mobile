// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutx/flutx.dart';
import 'package:go_router/go_router.dart';
import 'package:voccent/classroom/cubit/classroom_cubit.dart';
import 'package:voccent/classroom/cubit/models/classroom.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/widgets/loading_effect.dart';

class ClassroomWidget extends StatelessWidget {
  ClassroomWidget({super.key});

  final _typeAheadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mTheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            FeatherIcons.chevronLeft,
            size: 25,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        centerTitle: true,
        title: FxText.titleMedium(
          S.current.classroomClassroom.toUpperCase(),
          fontWeight: 600,
          textScaleFactor: 1.2257,
          color: mTheme.onPrimaryContainer,
        ),
      ),
      body: BlocConsumer<ClassroomCubit, ClassroomState>(
        listenWhen: (previous, current) => current.newClassroomCreating,
        listener: (context, state) {
          if (state.newClassroomCreating && state.newClassroomId != null) {
            Navigator.of(context).pop();
            context.read<ClassroomCubit>().classroomCreationDone();
            GoRouter.of(context).push('/classroom/${state.newClassroomId}');
          }
        },
        buildWhen: (previous, current) =>
            previous.classrooms.length != current.classrooms.length ||
            previous.uiLoading != current.uiLoading,
        builder: (context, state) {
          if (state.uiLoading) {
            return LoadingEffect.getSearchLoadingScreen(context, theme);
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    right: 8,
                    left: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => showDialog<void>(
                            context: context,
                            builder: (_) => BlocProvider.value(
                              value: context.read<ClassroomCubit>(),
                              child: AlertDialog(
                                title: Text(
                                  S.current.classroomCreateNewCr,
                                ),
                                content: TextField(
                                  maxLength: 42,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: S.current.classroomEnterCrName,
                                    counterText: S.current.classroomNameLength,
                                  ),
                                  onChanged: (text) {
                                    context
                                        .read<ClassroomCubit>()
                                        .setNewClassroomName(text);
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    child: FxText.bodyLarge(
                                      S.current.genericCancel,
                                    ),
                                    onPressed: () {
                                      context
                                          .read<ClassroomCubit>()
                                          .setNewClassroomName('');
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context
                                          .read<ClassroomCubit>()
                                          .createClassroom();
                                    },
                                    child: BlocSelector<ClassroomCubit,
                                        ClassroomState, String>(
                                      selector: (state) {
                                        return state.newClassroomName;
                                      },
                                      builder: (context, state) {
                                        return FxText.bodyLarge(
                                          S.current.genericCreate,
                                          color: context
                                                      .read<ClassroomCubit>()
                                                      .state
                                                      .newClassroomName
                                                      .length <
                                                  2
                                              ? mTheme.surface
                                              : mTheme.primary,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          child: FxContainer.bordered(
                            child: FxText.bodyLarge(
                              S.current.classroomCreateCr,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ),
                      ),
                      FxSpacing.width(8),
                      Expanded(
                        child: InkWell(
                          onTap: () => showDialog<void>(
                            context: context,
                            builder: (_) => BlocProvider.value(
                              value: context.read<ClassroomCubit>(),
                              child: AlertDialog(
                                title: Text(S.current.classroomJoinCr),
                                content: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: _buildSearchField(
                                    context,
                                    _typeAheadController,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: FxText.bodyLarge(
                                      S.current.genericCancel,
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  BlocSelector<ClassroomCubit, ClassroomState,
                                      bool>(
                                    selector: (state) {
                                      return state.canJoin;
                                    },
                                    builder: (context, canJoin) {
                                      return TextButton(
                                        onPressed: () {
                                          if (!canJoin) {
                                            return;
                                          }

                                          context
                                              .read<ClassroomCubit>()
                                              .joinClassroom(
                                                _typeAheadController.text,
                                              )
                                              .then(
                                                (_) =>
                                                    Navigator.of(context).pop(),
                                              );
                                        },
                                        child: FxText.bodyLarge(
                                          S.current.classroomAsk2Join,
                                          color: canJoin
                                              ? mTheme.primary
                                              : mTheme.surface,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          child: FxContainer.bordered(
                            child: FxText.bodyLarge(
                              S.current.classroomJoinCr,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                BlocSelector<ClassroomCubit, ClassroomState, int>(
                  selector: (state) {
                    return state.invitations.length;
                  },
                  builder: (context, length) {
                    if (length == 0) {
                      return const SizedBox();
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: FxText.bodyLarge(
                            S.current.classroomInvitations,
                            color: mTheme.onBackground,
                            fontWeight: 600,
                          ),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final classroom =
                                state.invitations[index].classroom;
                            final confirmation =
                                state.invitations[index].confirmation;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: FxContainer.bordered(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FxText.bodyLarge(
                                          classroom!.name!,
                                          fontWeight: 600,
                                        ),
                                        FxSpacing.height(8),
                                        FxText(
                                          confirmation!.status!,
                                          color: mTheme.primary,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        if (confirmation.status! ==
                                            'invited') ...[
                                          InkWell(
                                            onTap: () => context
                                                .read<ClassroomCubit>()
                                                .confirmJoin(classroom.name!),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 8,
                                              ),
                                              child: Icon(
                                                FeatherIcons.check,
                                                color: mTheme.primary,
                                              ),
                                            ),
                                          ),
                                          FxSpacing.width(8),
                                        ],
                                        InkWell(
                                          onTap: () => context
                                              .read<ClassroomCubit>()
                                              .cancelJoin(classroom.name!),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            child: Icon(
                                              FeatherIcons.x,
                                              color: mTheme.error,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: length,
                        ),
                      ],
                    );
                  },
                ),
                BlocSelector<ClassroomCubit, ClassroomState, int>(
                  selector: (state) {
                    return state.current.length;
                  },
                  builder: (context, length) {
                    if (length == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: FxText.bodyLarge('No classrooms'),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: FxText.bodyLarge(
                            S.current.classroomCurrentCr,
                            color: mTheme.onBackground,
                            fontWeight: 600,
                          ),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final classroom = state.current[index].classroom;
                            final confirmation =
                                state.current[index].confirmation;

                            return Slidable(
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  if (confirmation != null) ...[
                                    SlidableAction(
                                      onPressed: (_) => context
                                          .read<ClassroomCubit>()
                                          .cancelJoin(classroom!.name!),
                                      backgroundColor: mTheme.background,
                                      foregroundColor: mTheme.error,
                                      icon: FeatherIcons.delete,
                                      label: 'Cancel membership',
                                    ),
                                  ] else ...[
                                    SlidableAction(
                                      onPressed: (_) => GoRouter.of(context)
                                          .push('/classroom/${classroom!.id}'),
                                      backgroundColor: mTheme.background,
                                      foregroundColor: mTheme.primary,
                                      icon: FeatherIcons.edit,
                                      label: 'Edit',
                                    ),
                                    SlidableAction(
                                      onPressed: (_) => showDialog<void>(
                                        context: context,
                                        builder: (_) => BlocProvider.value(
                                          value: context.read<ClassroomCubit>(),
                                          child: AlertDialog(
                                            title: const Text(
                                              '''Do you really want to delete classroom?''',
                                            ),
                                            actions: [
                                              TextButton(
                                                child: FxText.bodyLarge(
                                                  S.current.genericCancel,
                                                ),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  context
                                                      .read<ClassroomCubit>()
                                                      .deleteClassroom(
                                                        classroom!.id,
                                                      );
                                                  Navigator.of(context).pop();
                                                },
                                                child: FxText.bodyLarge(
                                                  'Delete',
                                                  color: mTheme.error,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      backgroundColor: mTheme.background,
                                      foregroundColor: Colors.red,
                                      icon: FeatherIcons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ],
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: InkWell(
                                  onTap: () => GoRouter.of(context)
                                      .push('/classroom/${classroom.id}'),
                                  child: FxContainer.bordered(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FxText.bodyLarge(
                                              classroom!.name!,
                                              fontWeight: 600,
                                            ),
                                            FxSpacing.height(8),
                                            FxText(
                                              confirmation != null
                                                  ? confirmation.status!
                                                  : S.current.classroomOwner,
                                              color: mTheme.primary,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: length,
                        ),
                      ],
                    );
                  },
                ),
                if (state.rejected.isNotEmpty)
                  ExpansionTile(
                    title: Center(
                      child: FxText.bodyLarge(
                        S.current.classroomRejectedInv,
                        color: mTheme.onBackground,
                        fontWeight: 600,
                      ),
                    ),
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final classroom = state.rejected[index].classroom;
                          final confirmation =
                              state.rejected[index].confirmation;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: FxContainer.bordered(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FxText.bodyLarge(
                                        classroom!.name!,
                                        fontWeight: 600,
                                      ),
                                      FxSpacing.height(8),
                                      FxText(
                                        confirmation != null
                                            ? confirmation.status!
                                            : S.current.classroomOwner,
                                        color: mTheme.error,
                                      ),
                                    ],
                                  ),
                                  if (classroom.privacy == 'public')
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () => context
                                              .read<ClassroomCubit>()
                                              .joinClassroomAgain(
                                                classroom.name!,
                                              ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: Icon(
                                              FeatherIcons.refreshCw,
                                              color: mTheme.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: state.rejected.length,
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchField(
    BuildContext context,
    TextEditingController typeAheadController,
  ) {
    return PopScope(
      onPopInvoked: (didPop) {
        typeAheadController.text = '';
      },
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: typeAheadController,
          autofocus: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: S.current.classroomEnterCrName,
          ),
        ),
        suggestionsCallback: (pattern) async {
          context.read<ClassroomCubit>().setJoinButton(canJoin: false);
          return context.read<ClassroomCubit>().searchClassroom(pattern);
        },
        itemBuilder: (context, Classroom suggestion) {
          return ListTile(
            title: Text(suggestion.name!),
          );
        },
        onSuggestionSelected: (Classroom suggestion) {
          typeAheadController.text = suggestion.name!;
          context.read<ClassroomCubit>().setJoinButton(canJoin: true);
        },
      ),
    );
  }
}
