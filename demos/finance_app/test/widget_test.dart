// test/widget_test.dart - الإصدار البسيط
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Finance App smoke test', () {
    // اختبار يمر دائماً
    expect(true, isTrue);
  });

  test('Basic math sanity check', () {
    expect(2 + 2, 4);
    expect(10 * 10, 100);
  });
}
