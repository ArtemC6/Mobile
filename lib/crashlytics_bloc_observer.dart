import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CrashlyticsBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    log(event.toString(), name: 'Cubit');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log(error.toString(), name: 'Cubit');
    FirebaseCrashlytics.instance.log(
      'cubit error (${bloc.runtimeType}, $error)',
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log(change.toString(), name: 'Cubit');
    FirebaseCrashlytics.instance.log(
      'cubit state change(${bloc.runtimeType}, $change)',
    );
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    log(transition.toString(), name: 'Cubit');
  }
}
