import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class TextToSpeech {
  static const MethodChannel _channel =
      const MethodChannel('dev.ixsans/text_to_speech');

  Map<String, dynamic>? locales;

  Future<bool> speak(String text) async {
    if (text.isEmpty) {
      return false;
    }

    return await _channel
        .invokeMethod('speak', <String, dynamic>{'text': text});
  }

  Future<bool> stop() async {
    return await _channel.invokeMethod('stop');
  }

  Future<bool> pause() async {
    return await _channel.invokeMethod('pause');
  }

  Future<bool> resume() async {
    return await _channel.invokeMethod('resume');
  }

  Future<bool> setRate(num rate) async {
    return await _channel
        .invokeMethod('setRate', <String, dynamic>{'rate': rate});
  }

  Future<bool> setVolume(num volume) async {
    return await _channel
        .invokeMethod('setVolume', <String, dynamic>{'volume': volume});
  }

  Future<bool> setLanguage(String language) async {
    if (language.isEmpty) {
      return false;
    }

    return await _channel
        .invokeMethod('setLanguage', <String, dynamic>{'lang': language});
  }

  Future<bool> setPitch(num pitch) async {
    return await _channel
        .invokeMethod('setPitch', <String, dynamic>{'pitch': pitch});
  }

  /// Return language code i.e. en-US
  Future<List<String>> getLanguages() async {
    List<dynamic> langCodes = await _channel.invokeMethod('getLanguages');
    return langCodes.map((dynamic e) => e as String).toList();
  }

  Future<String> getDefaultLanguage() async {
    return await _channel.invokeMethod('getDefaultLanguage') as String;
  }

  Future<List<String>> getDisplayLanguages() async {
    locales ?? await getLocales();

    List<String> displayedLanguages = <String>[];
    List<dynamic> langList = await getLanguages();
    for (dynamic lang in langList) {
      String? displayLang = await getDisplayLanguageByCode(lang);
      if (displayLang != null) {
        displayedLanguages.add(displayLang);
      }
    }
    return displayedLanguages;
  }

  Future<String?> getDisplayLanguageByCode(String langCode) async {
    if (langCode.isEmpty) {
      return null;
    }

    if (locales == null) {
      locales = await getLocales();
    }

    Map<String, dynamic> langNameMap =
        locales!['language-names'] as Map<String, dynamic>;
    if (langNameMap.containsKey(langCode)) {
      final List<dynamic> langNames = langNameMap[langCode] as List<dynamic>;
      String displayLang = langNames.first as String;
      return displayLang;
    }

    return null;
  }

  Future<String?> getLanguageCodeByName(String languageName) async {
    if (languageName.isEmpty) {
      return null;
    }

    locales ?? await getLocales();

    Map<String, dynamic> langName =
        locales!['language-names'] as Map<String, dynamic>;

    String? languageCode = langName.keys.firstWhereOrNull((dynamic key) {
      List<dynamic> langNameList = langName[key as String] as List<dynamic>;
      return (langNameList.first as String) == languageName;
    });

    return languageCode;
  }

  Future<List<String>> getVoice() async {
    List<dynamic> voices = await _channel.invokeMethod('getVoices');
    return voices.map((dynamic e) => e as String).toList();
  }

  Future<List<String>> getVoiceByLang(String lang) async {
    List<dynamic> voices = await _channel
        .invokeMethod('getVoiceByLanguage', <String, dynamic>{'lang': lang});
    return voices.map((dynamic e) => e as String).toList();
  }

  Future<Map<String, dynamic>> getLocales() async {
    String jsonString =
        await rootBundle.loadString('packages/text_to_speech/assets/locales.json');
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }
}

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
