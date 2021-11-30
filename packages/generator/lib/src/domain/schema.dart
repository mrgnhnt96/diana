import 'package:diana/src/domain/argument_settings.dart';
import 'package:diana/src/domain/schema_field.dart';
import 'package:diana/src/exceptions/reserved_keyword.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template schema}
/// A schema retrieved from the yaml file
/// {@endtemplate}
class Schema extends Equatable {
  /// {@macro schema}
  Schema({
    required this.graphName,
    required this.classRef,
    required this.className,
    ArgumentSettings? argumentSettings,
    this.description,
    List<SchemaField> fields = const [],
  })  : allFields = fields,
        argumentSettings = argumentSettings ?? ArgumentSettings.empty() {
    ReservedWords.checkAll([graphName, className]);

    final flattenedFields =
        fields.fold<List<SchemaField>>(<SchemaField>[], (previousValue, e) {
      List<SchemaField> list;

      if (e.flatten) {
        list = e.fields.values.toList();
      } else {
        list = [e];
      }

      return previousValue..addAll(list);
    });

    this.fields = {
      for (final field in flattenedFields) field.propertyRef: field
    };
  }

  /// schema from json
  factory Schema.fromJson(Map<String, dynamic> json) => _schemaFromJson(json);

  /// Used to test schema
  @visibleForTesting
  factory Schema.manual({
    String className = '',
    String classRef = '',
    String description = '',
    String graphName = '',
    List<SchemaField> fields = const [],
    ArgumentSettings? argumentSettings,
  }) =>
      Schema(
        className: className,
        classRef: classRef,
        description: description,
        graphName: graphName,
        fields: fields,
        argumentSettings: argumentSettings ?? ArgumentSettings.empty(),
      );

  /// schema to json
  Map<String, dynamic> toJson() => _schemaToJson(this);

  /// The name of the schema that will be generated
  final String graphName;

  /// The name of the class that will be referenced
  final String classRef;

  /// The name of the class that will be generated
  final String className;

  /// The description, to be used in the documentation
  final String? description;

  /// The fields of the schema, mapped by the property name
  ///
  /// Fields are flattened
  late final Map<String, SchemaField> fields;

  /// the arguments of the schema
  final ArgumentSettings argumentSettings;

  /// All fields
  late final List<SchemaField> allFields;

  @override
  List<Object?> get props => [
        graphName,
        classRef,
        className,
        description,
        fields,
        argumentSettings,
        allFields,
      ];
}

Schema _schemaFromJson(Map<String, dynamic> json) {
  return Schema(
    graphName: json['graph_name'] as String,
    classRef: json['class_ref'] as String,
    className: json['class_name'] as String,
    description: json['description'] as String?,
    fields: SchemaField.rootFields(json['fields'] as Map<String, dynamic>?),
    argumentSettings:
        ArgumentSettings.fromJson(json['arguments'] as Map<String, dynamic>?),
  );
}

Map<String, dynamic> _schemaToJson(Schema instance) {
  return <String, dynamic>{
    'name': instance.graphName,
    'class_ref': instance.classRef,
    'class_name': instance.className,
    'description': instance.description,
    'all_fields': instance.allFields,
    'arguments': instance.argumentSettings,
    'fields': instance.fields.values.map((e) => e.toJson()).toList(),
  };
}
