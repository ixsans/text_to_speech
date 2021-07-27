package com.ixsans.text_to_speech

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MethodCallHandlerImpl(private val tts: Tts) :
    MethodChannel.MethodCallHandler {

    private var methodChannel: MethodChannel? = null

    fun startListening(messenger: BinaryMessenger) {
        methodChannel = MethodChannel(messenger, "dev.ixsans/text_to_speech")
        methodChannel!!.setMethodCallHandler(this)
    }

    fun stopListening() {
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "speak" -> {
                val text = call.argument<String>("text") ?: ""
                result.success(speak(text))
            }
            "stop" -> {
                result.success(stop())
            }
            "setVolume" -> {
                val volume = call.argument<Double>("volume")?.toFloat()
                if (volume != null) {
                    result.success(setVolume(volume))
                } else {
                    result.success(false)
                }

            }
            "setPitch" -> {
                val pitch = call.argument<Double>("pitch")?.toFloat()
                if (pitch != null) {
                    result.success(setPitch(pitch))
                } else {
                    result.success(false)
                }

            }
            "setRate" -> {
                val rate = call.argument<Double>("rate")?.toFloat()
                if (rate != null) {
                    result.success(setRate(rate))
                }else {
                    result.success(false)
                }
            }
            "setLanguage" -> {
                val lang = call.argument<String>("lang")
                if (lang != null) {
                    result.success(setLanguage(lang))
                }else {
                    result.success(false)
                }
            }
            "getDefaultLanguage" -> {
                val lang = getDefaultLanguage()
                result.success(lang)
            }
            "getLanguages" -> {
                val languages = getLanguage()
                result.success(languages)
            }
            "getVoice" -> {
                val voices = getVoices()
                result.success(voices)
            }
            "getVoiceByLanguage" -> {
                val lang = call.argument<String>("lang")
                val voices = getVoicesByLanguage(lang!!)
                result.success(voices)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun speak(text: String): Boolean {
        return tts.speak(text)
    }

    private fun stop(): Boolean {
        return tts.stop()
    }

    private fun setPitch(pitch: Float): Boolean {
        return tts.setPitch(pitch)
    }

    private fun setRate(rate: Float): Boolean {
        return tts.setRate(rate)
    }

    private fun setVolume(volume: Float): Boolean {
        return tts.setVolume(volume)
    }

    private fun setLanguage(lang: String): Boolean {
        return tts.setLanguage(lang)
    }

    private fun getDefaultLanguage(): String? {
        return tts.getDefaultLanguage()
    }

    private fun getLanguage(): List<String> {
        return tts.getAvailableLanguages()
    }

    private fun getVoices(): List<String> {
        return tts.getVoices()
    }

    private fun getVoicesByLanguage(lang: String): List<String> {
        return tts.getVoicesByLanguage(lang)
    }

}