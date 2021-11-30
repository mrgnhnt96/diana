// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template argument}
/// The argument for a graph query/mutation.
/// {@endtemplate}
class Argument extends Equatable {
  /// {@macro argument}
  Argument(
    String name, {
    required String type,
    String? defaultValue,
    bool? isRequired,
  }) : name = name.trim() {
    type = type.trim();
    _defaultValue = defaultValue?.trim().replaceAll('"', '');

    var isNullable = false, isReq = isRequired ?? false;

    if (_defaultValue == null) {
      isReq = true;
    } else {
      isNullable = false;
    }

    if (_defaultValue == null && isRequired == false) {
      isReq = false;
      isNullable = true;
    }

    if ((isRequired ?? false) && _defaultValue == null) {
      isReq = true;
    }

    if (type.contains('?')) {
      isNullable = true;
    }

    _isRequired = isReq;
    _isNullable = isNullable;
    _type = type;
    _isValueTypeString = type.startsWith('String');

    if (_isRequired && _defaultValue != null) {
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
    String? defaultValue,
    bool isRequired = false,
    bool isNullable = false,
    bool isValueTypeString = false,
  })  : _defaultValue = defaultValue,
        _type = type,
        _isRequired = isRequired,
        _isNullable = isNullable,
        _isValueTypeString = isValueTypeString;

  /// Creates an instance of [Argument] from a JSON [Map].
  factory Argument.fromJson(Map<String, dynamic> map) {
    final name = map['name'] as String?;
    final type = map['type'] as String?;

    if (name == null || type == null) {
      throw ArgumentError('The argument name and type must not be null');
    }

    return Argument(
      name,
      type: type,
      defaultValue: map['default_value'] as String?,
      isRequired: map['is_required'] as bool?,
    );
  }

  /// the name of the argument
  final String name;

  late final String? _defaultValue;
  late final String _type;
  late final bool _isValueTypeString;
  late final bool _isRequired;
  late final bool _isNullable;

  /// the default value of the argument
  String? get defaultValue {
    if (_defaultValue == null) {
      return null;
    }

    if (_isValueTypeString) {
      return '"$_defaultValue"';
    }

    return _defaultValue;
  }

  /// if the [type] is of type String
  bool get isValueTypeString => _isValueTypeString;

  /// whether the argument is required
  bool get isRequired => _isRequired;

  /// whether the argument is nullable
  bool get isNullable => _isNullable;

  /// the type of the argument
  String get type {
    final type = _type.replaceAll('?', '');

    if (_isNullable) {
      return '$type?';
    }

    return type;
  }

  @override
  List<Object?> get props => [
        name,
        type,
        defaultValue,
        isRequired,
        isNullable,
        isValueTypeString,
      ];

  /// Creates a JSON [Map] from this object.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'type': type,
      'defaultValue': defaultValue,
      'isRequired': isRequired,
      'isNullable': isNullable,
      'isValueTypeString': isValueTypeString,
    };
  }
}
