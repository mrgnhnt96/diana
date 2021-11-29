import 'package:meta/meta.dart';

/// {@template reserved_keyword_exception}
/// Thrown when a reserved keyword is used
/// {@endtemplate}
class ReservedKeywordException implements Exception {
  /// {@macro reserved_keyword_exception}
  const ReservedKeywordException(this.keyword);

  /// the keyword that was used
  final String keyword;

  @override
  String toString() => 'Reserved keyword $keyword';
}

const _reservedWords = {
  // dart specific
  'continue': '',
  'false': '',
  'new': '',
  'this': '',
  'default': '',
  'final': '',
  'null': '',
  'throw': '',
  'assert': '',
  'finally': '',
  'true': '',
  'do': '',
  'for': '',
  'try': '',
  'rethrow': '',
  'else': '',
  'if': '',
  'return': '',
  'var': '',
  'break': '',
  'enum': '',
  'void': '',
  'case': '',
  'while': '',
  'catch': '',
  'in': '',
  'super': '',
  'with': '',
  'class': '',
  'extends': '',
  'is': '',
  'switch': '',
  'const': '',
  'bool': '',
  'double': '',
  'dynamic': '',
  'int': '',
  'num': '',
};

/// {@macro reserved_keyword_exception}
class ReservedWords {
  /// Checks if the given [word] is a reserved keyword.
  static void check(String? word) {
    if (word == null) return;
    if (!_reservedWords.containsKey(word)) return;

    throw ReservedKeywordException(word);
  }

  /// Checks if the given [words] are reserved keywords.
  static void checkAll(Iterable<String?> words) {
    for (final word in words) {
      check(word);
    }
  }

  /// returns the list of reserved words
  @visibleForTesting
  static List<String> reservedWords() => _reservedWords.keys.toList();
}
