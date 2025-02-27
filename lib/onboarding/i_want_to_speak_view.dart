import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voccent/onboarding/cubit/onboarding_cubit.dart';
import 'package:voccent/onboarding/view/i_want_to_speak_form.dart';
import 'package:voccent/root/root_widget.dart';

class IWantToSpeakView extends StatelessWidget {
  const IWantToSpeakView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(
        context.read<ClientScopeClient>(),
        context.read<SharedPreferences>(),
      )..load(context),
      child: const IWantToSpeackForm(),
    );
  }
}
