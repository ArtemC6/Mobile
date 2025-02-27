part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  const ThemeState(this.theme);

  final ThemeData theme;

  @override
  List<Object> get props => [theme];
}
