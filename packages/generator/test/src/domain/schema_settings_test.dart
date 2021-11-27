import 'package:diana/src/domain/schema_settings.dart';
import 'package:test/test.dart';

void main() {
  test('parse', () async {
    final result = await SchemaSettings.parse('test/utils/test_graphql.yaml');

    print(result);
  });
}
