import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_shader_snap/flutter_shader_snap.dart';
import 'package:flutx/flutx.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/auth/auth_widget.dart';
import 'package:voccent/auth/cubit/auth_cubit.dart';
import 'package:voccent/generated/l10n.dart';
import 'package:voccent/home/cubit/home_cubit.dart';
import 'package:voccent/organizations/cubit/organization_cubit.dart';
import 'package:voccent/web_socket/web_socket.dart';
import 'package:voccent/widgets/dialog.dart';

class OrganizationsView extends StatefulWidget {
  const OrganizationsView({super.key});

  @override
  State<OrganizationsView> createState() => _OrganizationsViewState();
}

class _OrganizationsViewState extends State<OrganizationsView>
    with SingleTickerProviderStateMixin {
  bool _isAlreadyInOrg = false;

  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  Widget build(BuildContext context) {
    final mTheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => OrganizationCubit(
        context.read<UserScopeClient>(),
        context.read<WebSocket>(),
        context.read<AuthCubit>().state.userToken,
        context.read<SharedPreferences>(),
      )..init(context.read<HomeCubit>().state.user),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: FxText.titleMedium(
            S.current.organizations,
            fontWeight: 700,
            textScaleFactor: 1.2257,
            color: mTheme.onPrimaryContainer,
          ),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              FeatherIcons.chevronLeft,
              size: 25,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          centerTitle: true,
          actions: const [
            // Padding(
            //   padding: const EdgeInsets.all(8),
            //   child: IconButton(
            //     onPressed: () => Share.share(widget._url),
            //     icon: const Icon(FeatherIcons.share2),
            //     color: Theme.of(context).colorScheme.onBackground,
            //   ),
            // ),
          ],
        ),
        body: BlocBuilder<OrganizationCubit, OrganizationState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              children: [
                if (state.confirmations?.isEmpty ?? true)
                  Expanded(
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/lottie/search.json',
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          child: FxText.displayMedium(
                            S.current.thereAreNoOrganizations,
                            textAlign: TextAlign.center,
                            color: mTheme.onSurface.withOpacity(1),
                            fontWeight: 700,
                            fontSize: 23,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.confirmations?.length ?? 0,
                      itemBuilder: (context, index) {
                        final isInvited =
                            state.confirmations?[index].status == 'invited';
                        final w = S.current.weInviteUouJoinOrganization;
                        final name =
                            '${isInvited ? w : S.current.youAreOrganization}'
                            ' ${state.confirmations?[index].objectName}';
                        if (!isInvited) _isAlreadyInOrg = true;
                        final e = S.current.youAreAlreadyInOrganization;

                        return SnapShader(
                          controller: _controller,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: FxContainer(
                              marginAll: 8,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: FxText.bodyMedium(
                                      textAlign: TextAlign.center,
                                      name,
                                      fontWeight: 700,
                                      color: mTheme.onPrimaryContainer,
                                      fontSize: 22,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: FxButton.medium(
                                            backgroundColor: Colors.red,
                                            onPressed: () async {
                                              await _controller.forward();

                                              await Future.delayed(
                                                Duration.zero,
                                                () => context
                                                    .read<OrganizationCubit>()
                                                    .leaveOrganization(
                                                      state
                                                          .confirmations?[index]
                                                          .objectId,
                                                    ),
                                              );

                                              await Future.delayed(
                                                const Duration(
                                                  milliseconds: 800,
                                                ),
                                                () => _controller.reset(),
                                              );
                                            },
                                            child: FxText.bodyMedium(
                                              !isInvited
                                                  ? S.current.genericLeave
                                                  : S.current.reject,
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        if (isInvited)
                                          const SizedBox(width: 16),
                                        if (isInvited)
                                          Expanded(
                                            child: FxButton.medium(
                                              onPressed: () {
                                                if (!_isAlreadyInOrg) {
                                                  context
                                                      .read<OrganizationCubit>()
                                                      .joinOrganization(
                                                        state.confirmations?[
                                                            index],
                                                      );
                                                } else {
                                                  showInfoDialog(
                                                    context,
                                                    e,
                                                    null,
                                                  );
                                                }
                                              },
                                              child: FxText.bodyMedium(
                                                S.current.accept,
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
