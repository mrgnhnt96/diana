import 'basic_mutation.dart';
import 'basic_query.dart';
import 'no_query_mutation.dart';
import 'util/schema_test_intf.dart';

void main() {
  final tests = <SchemaTest Function()>[
    () => BasicQuery(),
    () => BasicMutation(),
    () => NoQueryMutation(),
  ];

  for (final test in tests) {
    test().verify();
  }
}
