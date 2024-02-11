import 'package:flutter_test/flutter_test.dart';
import 'package:letsgoi/screens/anki_add.dart';

void main() {
  test('Test if JMDict is already initialized', () {
    // Create an instance of JMDict
    final jmdict = JMDict();

    // Check if JMDict is already initialized
    expect(jmdict.isInitialized, isTrue);
  });
}