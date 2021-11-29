import 'package:equatable/equatable.dart';
import 'package:test/scaffolding.dart';

import 'graph_input/basic.dart';

void main() {
  final tests = [
    () => BasicGraph(),
  ];

  for (final t in tests) {
    t().verify();
  }
}
