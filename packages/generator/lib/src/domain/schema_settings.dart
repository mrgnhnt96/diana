import 'dart:io';

import 'package:diana/src/domain/schema.dart';
import 'package:diana/src/domain/schema_field.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

/// {@template schema_settings}
/// The settings retrieved from the yaml file
/// {@endtemplate}
class SchemaSettings extends Equatable {
  /// {@macro schema_settings}
  const SchemaSettings._({
    required this.queries,
    required this.mutations,
  });

  /// manually set the queries and mutations
  ///
  /// for testing only, should not be used in production
  @visibleForTesting
  const SchemaSettings.set({
    required this.queries,
    required this.mutations,
  });

  /// The queries defined
  final List<Schema> queries;

  /// The mutations defined
  final List<Schema> mutations;

  /// parses the yaml file into a [SchemaSettings]
  static Future<SchemaSettings?> parse(String path) async {
    final parsed = await _getSettings(path);

    if (parsed == null) {
      return null;
    }

    final queries = _getSchemas(parsed['queries'] as YamlMap?);
    final mutations = _getSchemas(parsed['mutations'] as YamlMap?);

    return SchemaSettings._(
      mutations: mutations,
      queries: queries,
    );
  }

  @override
  List<Object?> get props => [
        queries,
        mutations,
      ];
}

Future<YamlMap?> _getSettings(String path) async {
  final settings = File(path);
  final yaml = await settings.readAsString();

  final dynamic parsed = loadYaml(yaml);

  if (parsed == null) {
    return null;
  }

  return parsed as YamlMap;
}

List<Schema> _getSchemas(YamlMap? rawSchemas) {
  if (rawSchemas == null) {
    return [];
  }

  final schemaMaps = _convertFromYamlMap(rawSchemas);

  final schemas = <Schema>[];

  for (final entry in schemaMaps.entries) {
    final name = entry.key;
    final rawSchema = entry.value as Map<String, dynamic>;

    if (!rawSchema.containsKey('fields')) {
      throw Exception('Schema $name does not contain a fields key');
    }

    if (!rawSchema.containsKey('class_name')) {
      rawSchema['class_name'] = name;
    }

    rawSchema['fields'] =
        _getFields(rawSchema['fields'] as Map<String, dynamic>);

    final schema = Schema.fromJson(rawSchema);

    schemas.add(schema);
  }

  return schemas;
}

Map<String, dynamic> _convertFromYamlMap(YamlMap? map) {
  if (map == null || map.isEmpty) {
    return <String, dynamic>{};
  }

  final result = Map<String, dynamic>.from(map);

  for (final entry in result.entries) {
    if (entry.value is YamlMap) {
      result[entry.key] = _convertFromYamlMap(entry.value as YamlMap);
    }
  }

  return result;
}

List<SchemaField> _getFields(Map<String, dynamic>? rawFields) {
  final fields = <SchemaField>[];

  if (rawFields == null) {
    return fields;
  }

  for (final entry in rawFields.entries) {
    final name = entry.key;
    final rawField = entry.value as Map<String, dynamic>?;

    final field = SchemaField(
      name,
      propertyName: rawField?['property_ref'] as String? ?? name,
      flatten: rawField?['flatten'] as bool? ?? false,
      fields: _getFields(rawField?['fields'] as Map<String, dynamic>?),
    );

    fields.add(field);
  }

  return fields;
}
