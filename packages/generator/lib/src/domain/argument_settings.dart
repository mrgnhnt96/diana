import 'dart:collection';

import 'package:diana/src/domain/argument.dart';
import 'package:equatable/equatable.dart';

/// {@template argument_settings}
/// The argument settings for a graph query/mutation
/// {@endtemplate}
class ArgumentSettings extends Equatable with ListMixin<Argument> {
  /// {@macro argument_settings}
  const ArgumentSettings(this.arguments)
      : canBePositional = arguments.length == 1;

  /// returns no arguments
  ArgumentSettings.empty()
      : arguments = const [],
        canBePositional = false;

  /// Creates a new instance from a json object
  factory ArgumentSettings.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ArgumentSettings.empty();
    }

    final arguments = <Argument>[];

    for (final arg in json.entries) {
      final rawArg = arg.value as Map<String, dynamic>;
      rawArg['name'] = arg.key;

      final argument = Argument.fromJson(rawArg);

      arguments.add(argument);
    }

    return ArgumentSettings(arguments);
  }

  /// The list of arguments for the query/mutation
  final List<Argument> arguments;

  /// Whether the arguments can be positional
  ///
  /// Only applies if there is only one argument
  final bool canBePositional;

  @override
  List<Object?> get props => [arguments];

  /// converts this object to a json object
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'arguments': arguments.map((x) => x.toJson()).toList(),
      'canBePositional': canBePositional,
    };
  }

  @override
  int get length => arguments.length;

  @override
  set length(int index) =>
      throw UnsupportedError('Cannot set length of ArgumentSettings');

  @override
  Argument operator [](int index) => arguments[index];

  @override
  void operator []=(int index, Argument value) => arguments[index] = value;
}
