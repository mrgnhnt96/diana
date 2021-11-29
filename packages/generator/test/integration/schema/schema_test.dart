import 'basic_mutation.dart';
import 'basic_query.dart';
import 'no_arguments.dart';
import 'no_class_name.dart';
import 'no_fields.dart';
import 'no_query_mutation.dart';
import 'util/schema_test_intf.dart';

void main() {
  final tests = <SchemaTest Function()>[
    () => BasicQuery(),
    () => BasicMutation(),
    () => NoQueryMutation(),
    () => NoArguments(),
    () => NoFields(),
    () => NoClassName(),
  ];

  for (final test in tests) {
    test().verify();
  }
}
