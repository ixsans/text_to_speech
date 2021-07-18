import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:text_to_speech/text_to_speech.dart';

void main() {
  const MethodChannel channel = MethodChannel('text_to_speech');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await TextToSpeech.platformVersion, '42');
  });
}
