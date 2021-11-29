import 'package:diana/src/domain/argument.dart';

/// {@template argument_settings}
/// The argument settings for a graph query/mutation
/// {@endtemplate}
class ArgumentSettings {
  /// {@macro argument_settings}
  const ArgumentSettings({
    required this.arguments,
  }) : canBePositional = arguments.length == 1;

  /// The list of arguments for the query/mutation
  final List<Argument> arguments;

  /// Whether the arguments can be positional
  ///
  /// Only applies if there is only one argument
  final bool canBePositional;
}
