import 'package:change_case/change_case.dart';
import 'package:diana/src/domain/schema.dart';
import 'package:diana/src/domain/schema_field.dart';
import 'package:diana/src/domain/schema_settings.dart';

import 'util/schema_test_intf.dart';

class NoArguments extends SchemaTest {
  NoArguments() : super('$NoArguments'.toSnakeCase());

  @override
  SchemaSettings get expected => SchemaSettings.set(
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
}
