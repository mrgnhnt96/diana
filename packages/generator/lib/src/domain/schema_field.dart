/// {@template schema_field}
/// The field of a Schema
/// {@endtemplate}
class SchemaField {
  /// {@macro schema_field}
  const SchemaField({
    required this.fieldName,
    required this.propertyName,
    this.flatten = false,
    this.fields = const [],
  });

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

  /// The sub fields of this field
  final List<SchemaField> fields;
}
