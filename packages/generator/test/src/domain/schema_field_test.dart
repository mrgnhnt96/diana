import 'package:analyzer/dart/ast/ast.dart';
import 'package:diana/src/domain/schema_field.dart';
import 'package:diana/src/exceptions/reserved_keyword.dart';
import 'package:test/test.dart';

void main() {
  const defaultName = 'fieldName';

  group('#propertyName', () {
    test('should return #fieldName if null', () {
      final field = SchemaField(defaultName);

      expect(field.propertyName, defaultName);
    });

    test('should return propertyName arg', () {
      const propertyName = 'propertyName';
      final field = SchemaField(defaultName, propertyName: propertyName);

      expect(field.propertyName, propertyName);
    });
  });

  group('#fields', () {
    test('should return empty list if null', () {
      final field = SchemaField(defaultName);

      expect(field.fields, isEmpty);
    });

    test('should return fields arg', () {
      final fields = [SchemaField(defaultName)];
      final field = SchemaField(defaultName, fields: fields);

      expect(field.fieldsForTesting, fields);
    });

    test('should return mapped fields by #propertyName', () {
      const nestedFieldName = 'nestedFieldName';

      final nestedField = SchemaField(nestedFieldName);
      final fields = [nestedField];
      final field = SchemaField(defaultName, fields: fields);

      final expected = {nestedFieldName: nestedField};

      expect(field.fields, expected);
    });
  });

  group('reserved words', () {
    final reservedWords = ReservedWords.reservedWords();

    test('throws on fieldName', () {
      for (final word in reservedWords) {
        expect(
          () => SchemaField(word),
          throwsA(isA<ReservedKeywordException>()),
        );
      }
    });

    test('throws on propertyName', () {
      for (final word in reservedWords) {
        expect(
          () => SchemaField(defaultName, propertyName: word),
          throwsA(isA<ReservedKeywordException>()),
        );
      }
    });
  });

  group('#fromJson', () {
    test('fields type is list of $SchemaField', () {
      final json = {
        'field_name': 'fieldName',
        'property_name': 'fieldName',
        'fields': [SchemaField(defaultName)],
      };

      final field = SchemaField.fromJson(json);

      expect(field, isA<SchemaField>());
    });

    test('fields type is list of maps', () {
      final json = {
        'field_name': 'fieldName',
        'property_name': 'fieldName',
        'fields': [
          {
            'field_name': 'fieldName',
            'property_name': 'fieldName',
            'fields': <dynamic>[],
          },
        ],
      };

      final field = SchemaField.fromJson(json);

      expect(field, isA<SchemaField>());
    });
  });
}
