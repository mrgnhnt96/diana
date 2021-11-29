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
    this.description,
    required List<SchemaField> fields,
  }) : fieldsForTesting = fields {
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
      for (final field in flattenedFields) field.propertyName: field
    };
  }

  /// schema from json
  factory Schema.fromJson(Map<String, dynamic> json) => _$SchemaFromJson(json);

  /// Used to test schema
  @visibleForTesting
  factory Schema.manual({
    String className = '',
    String classRef = '',
    String description = '',
    String graphName = '',
    List<SchemaField> fields = const [],
  }) =>
      Schema(
        className: className,
        classRef: classRef,
        description: description,
        graphName: graphName,
        fields: fields,
      );

  /// schema to json
  Map<String, dynamic> toJson() => _$SchemaToJson(this);

  /// The name of the schema that will be generated
  final String graphName;

  /// The name of the class that will be referenced
  final String classRef;

  /// The name of the class that will be generated
  final String className;

  /// The description, to be used in the documentation
  final String? description;

  /// The fields of the schema, mapped by the property name
  late final Map<String, SchemaField> fields;

  /// used to test [fields]
  @visibleForTesting
  late final List<SchemaField> fieldsForTesting;

  @override
  List<Object?> get props => [
        graphName,
        classRef,
        className,
        description,
        fields,
      ];
}

Schema _$SchemaFromJson(Map<String, dynamic> json) {
  late final List<SchemaField> fields;

  if (json['fields'] is List<SchemaField>) {
    fields = json['fields'] as List<SchemaField>;
  } else {
    fields = (json['fields'] as List<Map<String, dynamic>>)
        .map((e) => SchemaField.fromJson(e))
        .toList();
  }

  return Schema(
    graphName: json['graph_name'] as String,
    classRef: json['class_ref'] as String,
    className: json['class_name'] as String,
    description: json['description'] as String?,
    fields: fields,
  );
}

Map<String, dynamic> _$SchemaToJson(Schema instance) {
  return <String, dynamic>{
    'name': instance.graphName,
    'class_ref': instance.classRef,
    'class_name': instance.className,
    'description': instance.description,
    'fields': instance.fields.values.map((e) => e.toJson()).toList(),
  };
}
