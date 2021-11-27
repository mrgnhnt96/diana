import 'package:diana/src/domain/schema_field.dart';

/// {@template schema}
/// A schema retrieved from the yaml file
/// {@endtemplate}
class Schema {
  /// {@macro schema}
  const Schema({
    required this.name,
    required this.classRef,
    required this.className,
    required this.description,
    required this.fields,
  });

  /// schema from json
  factory Schema.fromJson(Map<String, dynamic> json) => _$SchemaFromJson(json);

  /// schema to json
  Map<String, dynamic> toJson() => _$SchemaToJson(this);

  /// The name of the schema that will be generated
  final String name;

  /// The name of the class that will be referenced
  final String classRef;

  /// The name of the class that will be generated
  final String className;

  /// The description, to be used in the documentation
  final String description;

  /// The fields of the schema
  final List<SchemaField> fields;
}
