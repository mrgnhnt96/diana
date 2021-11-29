import 'package:change_case/change_case.dart';
import 'package:diana/src/domain/argument.dart';
import 'package:diana/src/domain/argument_settings.dart';
import 'package:diana/src/domain/schema.dart';
import 'package:diana/src/domain/schema_settings.dart';

import 'util/schema_test_intf.dart';

class NoFields extends SchemaTest {
  NoFields() : super('$NoFields'.toSnakeCase());

  @override
  SchemaSettings get expected => SchemaSettings.set(
        queries: [
          Schema(
            graphName: 'exampleQuery',
            description: 'This is an example query.',
            classRef: 'Example',
            className: 'ExampleQuery',
            argumentSettings: ArgumentSettings([
              Argument(
                'exampleArgument',
                type: 'String',
                defaultValue: '"default_value"',
                isRequired: false,
              )
            ]),
            fields: const [],
          )
        ],
      );

  @override
  Future<SchemaSettings?> getSettings() => SchemaSettings.parse(path);
}
