import 'package:diana/src/domain/schema.dart';
import 'package:diana/src/domain/schema_field.dart';
import 'package:diana/src/domain/schema_settings.dart';
import 'package:test/test.dart';

import '../../../utils/schema_test_intf.dart';

class BasicGraph extends SchemaTest {
  BasicGraph() : super('test/src/domain/graph_input/basic.yaml');

  @override
  SchemaSettings get expected => SchemaSettings.set(
        mutations: [],
        queries: [
          Schema(
            graphName: 'exampleQuery',
            description: 'This is an example query.',
            classRef: 'Example',
            className: 'ExampleQuery',
            fields: [
              SchemaField('string', propertyName: 'text'),
              SchemaField('whole'),
              SchemaField('decimal'),
              SchemaField('flag'),
              SchemaField('date'),
              SchemaField(
                'subfields',
                flatten: true,
                fields: [
                  SchemaField('list'),
                  SchemaField('map'),
                  SchemaField('set'),
                  SchemaField('child', propertyName: 'example'),
                ],
              ),
            ],
          )
        ],
      );

  @override
  Future<SchemaSettings?> getSettings() => SchemaSettings.parse(path);

  @override
  void verify() {
    test(path, () async {
      final settings = await getSettings();

      expect(settings, expected);
    });
  }
}
