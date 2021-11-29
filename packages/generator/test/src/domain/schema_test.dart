import 'package:diana/src/domain/schema.dart';
import 'package:diana/src/domain/schema_field.dart';
import 'package:diana/src/exceptions/reserved_keyword.dart';
import 'package:test/test.dart';

void main() {
  group('#fields', () {
    const defaultName = 'defaultName';
    final defaultField = SchemaField(defaultName);

    test('should have all fields', () {
      final fields = [defaultField];
      final schema = Schema.manual(
        fields: fields,
      );

      expect(schema.fieldsForTesting, fields);
    });

    test('should return fields mapped by propertyName', () {
      final fields = [defaultField];

      final fieldsMap = {defaultName: defaultField};

      final schema = Schema.manual(
        fields: fields,
      );

      expect(schema.fields, fieldsMap);
    });

    test('should flattens fields by flatten flag', () {
      const subFieldName = 'subFieldName';

      final subField = SchemaField(subFieldName);
      final field = SchemaField(defaultName, flatten: true, fields: [subField]);

      final schema = Schema.manual(
        fields: [field],
      );

      final expected = {
        subFieldName: subField,
      };

      expect(schema.fields, expected);
    });
  });

  group('reserved words', () {
    final reservedWords = ReservedWords.reservedWords();

    test('throws on graphName', () {
      for (final word in reservedWords) {
        expect(
          () => Schema.manual(graphName: word),
          throwsA(isA<ReservedKeywordException>()),
        );
      }
    });

    test('throws on className', () {
      for (final word in reservedWords) {
        expect(
          () => Schema.manual(className: word),
          throwsA(isA<ReservedKeywordException>()),
        );
      }
    });
  });
}
