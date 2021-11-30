import 'package:diana/src/domain/argument_settings.dart';
import 'package:diana/src/exceptions/reserved_keyword.dart';
import 'package:equatable/equatable.dart';

/// {@template schema_field}
/// The field of a Schema
/// {@endtemplate}
class SchemaField extends Equatable {
  /// {@macro schema_field}
  SchemaField(
    this.fieldName, {
    String? propertyName,
    this.flatten = false,
    ArgumentSettings? argumentSettings,
    List<SchemaField> fields = const [],
  })  : allFields = fields,
        propertyRef = propertyName ?? fieldName,
        argumentSettings = argumentSettings ?? ArgumentSettings.empty(),
        fields = {
          for (final field in fields) field.propertyRef: field,
        } {
    ReservedWords.checkAll([fieldName, propertyName]);
  }

  /// schema field from json
  factory SchemaField.fromJson(Map<String, dynamic> json) =>
      _schemaFieldFromJson(json);

  /// schema field to json
  Map<String, dynamic> toJson() => _schemaFieldToJson(this);

  /// The name of the field that will be generated
  final String fieldName;

  /// The name of the property that will be referenced from the class
  /// annotated with `@Diana`
  final String propertyRef;

  /// Whether to extract fields from this field & remove it from the schema
  final bool flatten;

  /// The sub fields of this field, mapped by the property name
  final Map<String, SchemaField> fields;

  /// The sub fields of this field
  final List<SchemaField> allFields;

  /// The arguments of this field
  final ArgumentSettings argumentSettings;

  @override
  List<Object?> get props => [
        fieldName,
        propertyRef,
        flatten,
        fields,
        argumentSettings,
      ];

  /// Gets fields at root level
  static List<SchemaField> rootFields(Map<String, dynamic>? json) {
    final fields = <SchemaField>[];

    if (json == null) {
      return fields;
    }

    for (final entry in json.entries) {
      final name = entry.key;
      final rawField =
          entry.value as Map<String, dynamic>? ?? <String, dynamic>{};

      rawField.addAll(<String, dynamic>{
        'field_name': name,
        'property_ref': rawField['property_ref'] ?? name,
      });

      fields.add(_schemaFieldFromJson(rawField));
    }

    return fields;
  }
}

SchemaField _schemaFieldFromJson(Map<String, dynamic> json) {
  return SchemaField(
    json['field_name'] as String,
    propertyName: json['property_ref'] as String,
    flatten: json['flatten'] as bool? ?? false,
    fields: SchemaField.rootFields(json['fields'] as Map<String, dynamic>?),
    argumentSettings:
        ArgumentSettings.fromJson(json['arguments'] as Map<String, dynamic>?),
  );
}

Map<String, dynamic> _schemaFieldToJson(SchemaField instance) {
  return <String, dynamic>{
    'field_name': instance.fieldName,
    'property_ref': instance.propertyRef,
    'flatten': instance.flatten,
    'fields': instance.fields.values.map((e) => e.toJson()).toList(),
    'arguments': instance.argumentSettings.toJson(),
  };
}
