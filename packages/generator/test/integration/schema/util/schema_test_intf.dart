import 'package:diana/src/domain/schema_settings.dart';
import 'package:test/test.dart';

abstract class SchemaTest {
  const SchemaTest(this.fileName)
      : path = 'test/integration/schema/input/$fileName.yaml';

  Future<SchemaSettings?> getSettings();
  final String path;
  final String fileName;
  SchemaSettings? get expected;

  void verify() {
    test(fileName, () async {
      final settings = await getSettings();

      expect(settings, expected);
    });
  }
}
