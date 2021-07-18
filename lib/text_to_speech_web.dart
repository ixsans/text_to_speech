import 'dart:async';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart:js';

enum TtsStatus {
  playing,
  stopped,
  paused,
  resumed,
  error
}

/// A web implementation of the TextToSpeech plugin.
class TextToSpeechWeb {
  TextToSpeechWeb() {
    _init();
  }

  TtsStatus status = TtsStatus.stopped;
  html.SpeechSynthesisUtterance? utterance;
  html.SpeechSynthesis? synth;
  List<String> languages = <String>[];

  void _init() {
    utterance = html.SpeechSynthesisUtterance();
    synth = html.window.speechSynthesis;
    _listenState();
  }

  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'dev.ixsans/text_to_speech',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = TextToSpeechWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'speak':
        String text = call.arguments['text'];
        return speak(text);
      case 'stop':
        return stop();
      case 'pause':
        return pause();
      case 'resume':
        return resume();
      case 'setRate':
        num rate = call.arguments['rate'];
        return setRate(rate);
      case 'setVolume':
        num vol = call.arguments['volume'];
        return setVolume(vol);
      case 'setPitch':
        num pitch = call.arguments['pitch'];
        return setPitch(pitch);
      case 'setLanguage':
        String lang = call.arguments['lang'];
        return setLanguage(lang);
    /*case 'setVoice':
        String voice = call.arguments['voice'];
        return setVoice(voice);*/
      case 'getLanguages':
        return getLanguages();
      case 'getDefaultLanguage':
        return getDefaultLanguage();
      case 'getVoices':
        return getVoices();
      case 'getVoiceByLanguage':
        String lang = call.arguments['lang'];
        return getVoiceByLanguage(lang);
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'tts for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  void _listenState() {
    if (utterance == null) {
      throw PlatformException(
        code: 'Uninitialised',
        details: 'SpeechSynthesisUtterance is not ready',
      );
    }

    utterance!.onStart.listen((event) {
      status = TtsStatus.playing;
    });
    utterance!.onEnd.listen((event) {
      status = TtsStatus.stopped;
    });
    utterance!.onPause.listen((event) {
      status = TtsStatus.paused;
    });
    utterance!.onResume.listen((event) {
      status = TtsStatus.resumed;
    });
    utterance!.onError.listen((event) {
      status = TtsStatus.error;

      /// re-initialise instance when error occurred
      _init();
    });
  }

  bool speak(String text) {
    if (status != TtsStatus.stopped && status != TtsStatus.playing) {
      return false;
    }

    stop();
    utterance!.text = text;
    synth!.speak(utterance!);
    return true;
  }

  bool stop() {
    if (status != TtsStatus.playing) {
      return false;
    }

    synth!.cancel();
    return true;
  }

  bool pause() {
    if (status != TtsStatus.playing) {
      return false;
    }

    try {
      synth!.pause();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  bool resume() {
    if (status != TtsStatus.paused) {
      return false;
    }

    try {
      synth!.resume();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  bool setRate(num rate) {
    try {
      if (utterance != null) {
        utterance!.rate = rate;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  bool setVolume(num volume) {
    try {
      if (utterance != null) {
        utterance!.volume = volume;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  bool setPitch(num pitch) {
    try {
      if (utterance != null) {
        utterance!.pitch = pitch;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  bool setLanguage(String lang) {
    try {
      if (utterance != null) {
        utterance!.lang = lang;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }


  /// Return list of supported language code (i.e en-US)
  /// SpeechSynthesis Web API doesn't provide specific function to get supported language
  /// We get it from getVoice function instead
  List<String> getLanguages() {
    List<String> voices = _getVoicesLang();

    /// Prevent convert to Set first to avoid duplication and convert back to list
    return voices.toSet().toList();
  }

  /// Return default language code
  /// As no available native function, just return 'en-US'
  String getDefaultLanguage() {
    return 'en-US';
  }

  /// Returns native JS voice array
  JsArray<dynamic>? _getVoices() {
    return context['speechSynthesis'].callMethod('getVoices') as JsArray<dynamic>?;
  }

  /// Returns voice name (i.e Alice)
  List<String> getVoices() {
    List<String> voices = <String>[];
    JsArray<dynamic>? voiceArray = _getVoices();
    if (voiceArray != null) {
      for (dynamic voice in voiceArray) {
        if (voice != null) {
          voices.add(voice['name']);
        }
      }
    }
    return voices;
  }

  List<String> getVoiceByLanguage(String lang) {
    List<String> voices = <String>[];
    JsArray<dynamic>? voiceArray = _getVoices();
    if (voiceArray != null) {
      for (dynamic voice in voiceArray) {
        if (voice != null) {
          if (voice['lang'] == lang) {
            voices.add(voice['name'] as String);
          }
        }
      }
    }
    return voices;
  }

  /// Return language of supported voice
  List<String> _getVoicesLang() {
    JsArray<dynamic>? voiceArray = _getVoices();
    List<String> voices = <String>[];
    if (voiceArray != null) {
      for (dynamic voice in voiceArray) {
        if (voice != null) {
          voices.add(voice['lang']);
        }
      }
    }
    return voices;
  }

  /// not supported yet
  /*bool _setVoice(String voice) {
    try {
      if (utterance != null ) {
        //utterance!.voice = voice
        return false;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }*/
}
