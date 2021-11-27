import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:diana_annotation/diana.dart';
import 'package:source_gen/source_gen.dart';

/// {@template diana_generator}
/// A [Generator] that generates a [Diana] class for a given [ClassElement].
/// {@endtemplate}
class DianaGenerator extends GeneratorForAnnotation<Diana> {
  /// {@macro diana_generator}
  const DianaGenerator();

  @override
  Iterable<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    return {};
  }
}
