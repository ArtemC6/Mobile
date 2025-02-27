part of 'error_guard_cubit.dart';

class ErrorGuardState extends Equatable {
  const ErrorGuardState(
    this.error,
    this.occuredAt, {
    this.enabled = kDebugMode,
  });

  final Object error;
  final DateTime occuredAt;
  final bool enabled;

  @override
  List<Object> get props => [error, occuredAt, enabled];
}
