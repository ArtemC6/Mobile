import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [FirebaseUser.empty] represents an unauthenticated user.
/// {@endtemplate}
class FirebaseUser extends Equatable {
  /// {@macro user}
  const FirebaseUser({
    required this.id,
    required this.firebaseIdToken,
    this.email,
    this.name,
    this.photo,
  });

  /// The current user's email address.
  final String? email;

  /// The current user's id.
  final String id;

  /// Firebase IdToken.
  final Future<String?> Function() firebaseIdToken;

  /// The current user's name (display name).
  final String? name;

  /// Url for the current user's photo.
  final String? photo;

  /// Empty user which represents an unauthenticated user.
  static FirebaseUser empty = FirebaseUser(
    id: '',
    firebaseIdToken: () => Future.value(''),
  );

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == FirebaseUser.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != FirebaseUser.empty;

  @override
  List<Object?> get props => [email, id, name, photo];
}
