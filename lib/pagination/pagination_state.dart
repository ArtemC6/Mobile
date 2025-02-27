import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

/// Статус стейта [PaginationState]
enum Status { initial, success, failure }

@JsonSerializable(genericArgumentFactories: true)
class PaginationState<TLoaded> extends Equatable {
  const PaginationState({
    this.status = Status.initial,
    this.hasReachedMax = false,
    this.list = const [],
    this.error,
  });

  final Status status;
  final List<TLoaded> list;
  final bool hasReachedMax;
  final Object? error;

  PaginationState<TLoaded> copyWith({
    Status? status,
    List<TLoaded>? list,
    bool? hasReachedMax,
    Object? error,
  }) {
    return PaginationState(
      status: status ?? this.status,
      list: list ?? this.list,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, list, hasReachedMax, error];
}
