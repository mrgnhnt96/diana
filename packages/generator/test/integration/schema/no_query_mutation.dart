import 'package:change_case/change_case.dart';
import 'package:diana/src/domain/schema_settings.dart';
import 'package:test/test.dart';

import 'util/schema_test_intf.dart';

class NoQueryMutation extends SchemaTest {
  NoQueryMutation() : super('$NoQueryMutation'.toSnakeCase());

  @override
  SchemaSettings? get expected => null;

  @override
  Future<SchemaSettings?> getSettings() => SchemaSettings.parse(path);

  @override
  void verify() {
    test(fileName, () async {
      final settings = await getSettings();

      expect(settings, expected);
    });
  }
}
