import 'dart:io';

import 'package:diana/src/domain/schema.dart';
import 'package:yaml/yaml.dart';

/// {@template schema_settings}
/// The settings retrieved from the yaml file
/// {@endtemplate}
class SchemaSettings {
  /// {@macro schema_settings}
  const SchemaSettings._({
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

    rawSchema['fields'] =
        Map<String, dynamic>.from(rawSchema['fields'] as YamlMap);

    if (!rawSchema.containsKey('class_name')) {
      rawSchema['class_name'] = name;
    }

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
