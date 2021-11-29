import 'package:diana/src/domain/argument.dart';
import 'package:diana/src/domain/argument_settings.dart';
import 'package:test/test.dart';

void main() {
  final arg = Argument.manual();

  group('#canBePositional', () {
    group('should be true', () {
      test('when only 1 argument exists', () {
        final settings = ArgumentSettings(arguments: [arg]);

        expect(settings.canBePositional, isTrue);
      });
    });

    group('should be false', () {
      test('when more than 1 argument', () {
        final settings = ArgumentSettings(arguments: [arg, arg]);

        expect(settings.canBePositional, isFalse);
      });

      test('when no arguments', () {
        final settings = ArgumentSettings(arguments: []);

        expect(settings.canBePositional, isFalse);
      });
    });
  });
}
