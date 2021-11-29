// ignore_for_file: avoid_redundant_argument_values

import 'package:diana/src/domain/argument.dart';
import 'package:test/test.dart';

void main() {
  group('#isRequired', () {
    group('should be required', () {
      test('when defaultValue is null', () {
        final arg = Argument(
          'arg',
          type: 'String',
        );

        expect(arg.isRequired, isTrue);
      });

      test('when required is true', () {
        final arg = Argument(
          'arg',
          type: 'String',
          isRequired: true,
        );

        expect(arg.isRequired, isTrue);
      });
    });

    group('should not be required', () {
      test('when defaultValue is not null', () {
        final arg = Argument(
          'arg',
          type: 'String',
          defaultValue: 'default',
        );

        expect(arg.isRequired, isFalse);
      });

      test('when required is false', () {
        final arg = Argument(
          'arg',
          type: 'String',
          isRequired: false,
        );

        expect(arg.isRequired, isFalse);
      });

      test('when required is false and defaultValue is not null', () {
        final arg = Argument(
          'arg',
          type: 'String',
          isRequired: false,
          defaultValue: 'default',
        );

        expect(arg.isRequired, isFalse);
      });
    });

    test('should throw argument error when isRequired and has default value',
        () {
      expect(
        () => Argument(
          'arg',
          type: 'String',
          isRequired: true,
          defaultValue: 'default',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('#isNullable', () {
    group('should be nullable', () {
      test('when type contains `?`', () {
        final arg = Argument(
          'arg',
          type: 'String?',
        );

        expect(arg.isNullable, isTrue);
      });

      test('when required is false and defaultValue is null', () {
        final arg = Argument(
          'arg',
          type: 'String',
          isRequired: false,
        );

        expect(arg.isNullable, isTrue);
      });

      test('when required is true and `?` is in type', () {
        final arg = Argument(
          'arg',
          type: 'String?',
          isRequired: true,
        );

        expect(arg.isNullable, isTrue);
      });
    });

    group('should not be nullable', () {
      test('when defaultValue is null and isRequired is false', () {
        final arg = Argument(
          'arg',
          type: 'String',
        );

        expect(arg.isNullable, isFalse);
      });

      test('defaultValue is not null', () {
        final arg = Argument(
          'arg',
          type: 'String',
          defaultValue: 'default',
        );

        expect(arg.isNullable, isFalse);
      });
    });
  });

  group('#type', () {
    group('should not be nullable', () {
      test('when type is not nullable', () {
        final arg = Argument.manual(
          name: 'arg',
          type: 'String',
        );

        expect(arg.type, 'String');
      });

      test('when isNullable is set to false', () {
        final arg = Argument.manual(
          name: 'arg',
          type: 'String?',
          isNullable: false,
        );

        expect(arg.type, 'String');
      });
    });

    group('should be nullable', () {
      test('when type is  nullable', () {
        final arg = Argument.manual(
          name: 'arg',
          type: 'String?',
        );

        expect(arg.type, 'String?');
      });

      test('when isNullable is set to true', () {
        final arg = Argument.manual(
          name: 'arg',
          type: 'String',
          isNullable: true,
        );

        expect(arg.type, 'String?');
      });
    });
  });
}
