// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template argument}
/// The argument for a graph query/mutation.
/// {@endtemplate}
class Argument extends Equatable {
  /// {@macro argument}
  Argument({
    required this.name,
    required String type,
    this.defaultValue,
    bool? isRequired,
  }) {
    var _isNullable = false, _isRequired = isRequired ?? false;

    if (defaultValue == null) {
      _isRequired = true;
    } else {
      _isNullable = false;
    }

    if (defaultValue == null && isRequired == false) {
      _isRequired = false;
      _isNullable = true;
    }

    if ((isRequired ?? false) && defaultValue == null) {
      _isRequired = true;
    }

    if (type.contains('?')) {
      _isNullable = true;
    }

    this.isRequired = _isRequired;
    isNullable = _isNullable;
    _type = type;

    if (this.isRequired && defaultValue != null) {
      throw ArgumentError(
        'Argument $name is required but has a default value.',
      );
    }
  }

  /// used for testing only
  @visibleForTesting
  Argument.manual({
    this.name = '',
    String type = '',
    this.defaultValue,
    this.isRequired = false,
    this.isNullable = false,
  }) : _type = type;

  /// Creates an instance of [Argument] from a JSON [Map].
  factory Argument.fromJson(Map<String, dynamic> map) {
    final name = map['name'] as String?;
    final type = map['type'] as String?;

    if (name == null || type == null) {
      throw ArgumentError('The argument name and type must not be null');
    }

    return Argument(
      name: name,
      type: type,
      defaultValue: map['default_value'] as String?,
      isRequired: map['is_required'] as bool?,
    );
  }

  /// the name of the argument
  final String name;

  /// the type of the argument
  late final String _type;

  /// the default value of the argument
  final String? defaultValue;

  /// whether the argument is required
  late final bool isRequired;

  /// whether the argument is nullable
  late final bool isNullable;

  /// the type of the argument
  String get type {
    if (isNullable) {
      return '$_type?';
    }

    return _type.replaceAll('?', '');
  }

  @override
  List<Object?> get props => [
        name,
        _type,
        defaultValue,
      ];

  /// Creates a JSON [Map] from this object.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'type': type,
      'defaultValue': defaultValue,
      'isRequired': isRequired,
      'isNullable': isNullable,
    };
  }
}
