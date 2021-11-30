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
        propertyName = propertyName ?? fieldName,
        argumentSettings = argumentSettings ?? ArgumentSettings.empty(),
        fields = {
          for (final field in fields) field.propertyName: field,
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
  final String propertyName;

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
        propertyName,
        flatten,
        fields,
        argumentSettings,
      ];

  /// performs check if the [json] is type of [SchemaField]
  static List<SchemaField> fieldsFrom(List json) {
    late final List<SchemaField> fields;

    if (json is List<SchemaField>) {
      fields = json;
    } else {
      fields = json
          .map((dynamic e) => SchemaField.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return fields;
  }
}

SchemaField _schemaFieldFromJson(Map<String, dynamic> json) {
  return SchemaField(
    json['field_name'] as String,
    propertyName: json['property_name'] as String,
    flatten: json['flatten'] as bool? ?? false,
    fields: SchemaField.fieldsFrom(json['fields'] as List),
    argumentSettings: ArgumentSettings.from(json['arguments']),
  );
}

Map<String, dynamic> _schemaFieldToJson(SchemaField instance) {
  return <String, dynamic>{
    'field_name': instance.fieldName,
    'property_name': instance.propertyName,
    'flatten': instance.flatten,
    'fields': instance.fields.values.map((e) => e.toJson()).toList(),
    'arguments': instance.argumentSettings.toJson(),
  };
}
