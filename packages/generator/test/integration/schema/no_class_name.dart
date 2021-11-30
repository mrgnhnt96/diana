import 'package:change_case/change_case.dart';
import 'package:diana/src/domain/schema.dart';
import 'package:diana/src/domain/schema_settings.dart';

import 'util/schema_test_intf.dart';

class NoClassName extends SchemaTest {
  NoClassName() : super('$NoClassName'.toSnakeCase());

  @override
  SchemaSettings get expected => SchemaSettings.set(
        queries: [
          Schema(
            graphName: 'exampleQuery',
            description: 'This is an example query.',
            classRef: 'Example',
            className: 'ExampleQuery',
          )
        ],
      );

  @override
  Future<SchemaSettings?> getSettings() => SchemaSettings.parse(path);
}
