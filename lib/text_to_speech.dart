import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:text_to_speech_platform_interface/text_to_speech_platform.dart';

/// TextToSpeech class provides bridge between flutter and platform specific Text-To-Speech (TTS) API
///
/// This class communicate to platform interface through [TextToSpeechPlatform] instance that contains
/// subset of TTS native API from respective supported platforms.
class TextToSpeech {

  /// Start speak new utterance
  ///
  /// If there's running utterance, it will be stopped immediately and new utterance will starts
  Future<bool?> speak(String text) => TextToSpeechPlatform.instance.speak(text);

  /// Stop current utterance immediately
  Future<bool?> stop() => TextToSpeechPlatform.instance.stop();

  /// Pause current utterance immediately.
  ///
  /// This feature only available on iOS, macOS and web
  Future<bool?> pause() => TextToSpeechPlatform.instance.pause();

  /// Resume current utterance immediately.
  ///
  /// This feature only available on iOS, macOS and web
  Future<bool?> resume() => TextToSpeechPlatform.instance.resume();

  /// Set rate (tempo) for next utterance
  ///
  /// 1.0 is the normal speech rate, lower values slow down the speech (0.5 is half the normal speech rate),
  /// greater values accelerate it (2.0 is twice the normal speech rate).
  Future<bool?> setRate(num rate) =>
      TextToSpeechPlatform.instance.setRate(rate);

  /// Set volume of next utterance
  ///
  /// Volume is specified as a float ranging from 0 to 1 where 0 is silence, and 1 is the maximum volume (the default behavior).
  Future<bool?> setVolume(num volume) =>
      TextToSpeechPlatform.instance.setVolume(volume);

  /// Set pitch of next utterance
  ///
  /// 1.0 is the normal pitch, lower values lower the tone of the synthesized voice, greater values increase it.
  Future<bool?> setPitch(num pitch) =>
      TextToSpeechPlatform.instance.setPitch(pitch);

  /// Set volume for next utterance
  Future<bool?> setLanguage(String language) =>
      TextToSpeechPlatform.instance.setLanguage(language);

  /// Return list of supported language code (i.e en-US)
  /// SpeechSynthesis Web API doesn't provide specific function to get supported language
  /// We get it from getVoice function instead
  Future<List<String>> getLanguages() =>
      TextToSpeechPlatform.instance.getLanguages();

  /// Returns default language
  Future<String?> getDefaultLanguage() =>
      TextToSpeechPlatform.instance.getDefaultLanguage();

  /// Returns list of language names (e.g English, Arabic)
  Future<List<String>?> getDisplayLanguages() =>
      TextToSpeechPlatform.instance.getDisplayLanguages();

  /// Returns list of language names by given [langCode]
  ///
  /// [langCode] is language code (e.g en-US)
  Future<String?> getDisplayLanguageByCode(String langCode) =>
      TextToSpeechPlatform.instance.getDisplayLanguageByCode(langCode);

  /// Returns language code by given [languageName]
  ///
  /// [languageName] should be from locales from [text_to_speech_platform_interface]
  Future<String?> getLanguageCodeByName(String languageName) =>
      TextToSpeechPlatform.instance.getLanguageCodeByName(languageName);

  /// Return supported voices
  Future<List<String>?> getVoice() => TextToSpeechPlatform.instance.getVoice();

  /// Return list of voice by given [lang]
  ///
  /// [lang] is language code (e.g en-US)
  Future<List<String>?> getVoiceByLang(String lang) =>
      TextToSpeechPlatform.instance.getVoiceByLang(lang);
}
