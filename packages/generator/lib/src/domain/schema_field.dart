import 'package:diana/src/exceptions/reserved_keyword.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template schema_field}
/// The field of a Schema
/// {@endtemplate}
class SchemaField extends Equatable {
  /// {@macro schema_field}
  SchemaField(
    this.fieldName, {
    String? propertyName,
    this.flatten = false,
    List<SchemaField> fields = const [],
  })  : _fields = fields,
        propertyName = propertyName ?? fieldName,
        fields = {
          for (final field in fields) field.propertyName: field,
        } {
    ReservedWords.checkAll([fieldName, propertyName]);
  }

  /// schema field from json
  factory SchemaField.fromJson(Map<String, dynamic> json) =>
      _$SchemaFieldFromJson(json);

  /// schema field to json
  Map<String, dynamic> toJson() => _$SchemaFieldToJson(this);

  /// The name of the field that will be generated
  final String fieldName;

  /// The name of the property that will be referenced from the class
  /// annotated with `@Diana`
  final String propertyName;

  /// Whether to extract fields from this field & remove it from the schema
  final bool flatten;

  /// The sub fields of this field, mapped by the property name
  final Map<String, SchemaField> fields;

  final List<SchemaField> _fields;

  /// The sub fields of this field
  @visibleForTesting
  List<SchemaField> get fieldsForTesting => _fields;

  @override
  List<Object?> get props => [
        fieldName,
        propertyName,
        flatten,
        fields,
      ];
}

SchemaField _$SchemaFieldFromJson(Map<String, dynamic> json) {
  late final List<SchemaField> fields;

  if (json['fields'] is List<SchemaField>) {
    fields = json['fields'] as List<SchemaField>;
  } else {
    fields = (json['fields'] as List<dynamic>)
        .map((dynamic e) => SchemaField.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  return SchemaField(
    json['field_name'] as String,
    propertyName: json['property_name'] as String,
    flatten: json['flatten'] as bool? ?? false,
    fields: fields,
  );
}

Map<String, dynamic> _$SchemaFieldToJson(SchemaField instance) {
  return <String, dynamic>{
    'field_name': instance.fieldName,
    'property_name': instance.propertyName,
    'flatten': instance.flatten,
    'fields': instance.fields.values.map((e) => e.toJson()).toList(),
  };
}
