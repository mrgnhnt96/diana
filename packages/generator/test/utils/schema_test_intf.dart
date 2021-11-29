import 'package:diana/src/domain/schema_settings.dart';

abstract class SchemaTest {
  const SchemaTest(this.path);

  Future<SchemaSettings?> getSettings();
  final String path;
  SchemaSettings get expected;

  void verify();
}
