package com.ixsans.text_to_speech

import android.content.Context
import android.os.Bundle
import android.speech.tts.TextToSpeech
import android.speech.tts.UtteranceProgressListener
import android.util.Log
import java.util.*

class Tts(context: Context)  {

    companion object {
        const val TAG: String = "TTS"
    }

    private lateinit var tts: TextToSpeech
    private var volume: Float = 0.5f
    private var supportedLanguages: List<String> = emptyList()
    private var supportedVoices: List<String> = emptyList()

    init {
        tts = TextToSpeech(context
        ) { status: Int ->
            if (status == TextToSpeech.SUCCESS) {
                /// load languages & voices
                getAvailableLanguages()
                getVoices()

                tts.setOnUtteranceProgressListener( object : UtteranceProgressListener(){
                    override fun onStart(utteranceId: String?) {
                        Log.d(TAG, "Utterance started")
                    }

                    override fun onDone(utteranceId: String?) {
                        Log.d(TAG, "Utterance completed")
                    }

                    override fun onError(utteranceId: String?) {
                        Log.d(TAG, "Utterance error")
                    }
                })
            } else {
                Log.e(TAG, "TTS Initialisation failed")
            }
        }

    }
    
    fun speak(text: String): Boolean {
        val params = Bundle()
        params.putFloat(TextToSpeech.Engine.KEY_PARAM_VOLUME, volume)
        val result = tts.speak(text, TextToSpeech.QUEUE_FLUSH, params, "")
        return result == TextToSpeech.SUCCESS
    }

    fun stop(): Boolean {
        return tts.stop() == TextToSpeech.SUCCESS
    }

    fun setRate(rate: Float): Boolean {
        return tts.setSpeechRate(rate) == TextToSpeech.SUCCESS
    }

     fun setVolume(vol: Float): Boolean {
        volume = vol
        return true
    }

    // Set Language by given locale (locale format: en_US)
    fun setLanguage(lang: String): Boolean {
        if (!tts.availableLanguages.isNullOrEmpty()) {
            val selectedLocale: Locale? = tts.availableLanguages.firstOrNull {
                it.toLanguageTag() == lang
            }
            if (selectedLocale != null) {
                tts.language = selectedLocale
                return true
            }
        }

        return false
    }

    fun setPitch(pitch: Float): Boolean {
        return tts.setPitch(pitch) == TextToSpeech.SUCCESS
    }

    fun getDefaultLanguage(): String? {
        return tts.defaultVoice?.locale?.toLanguageTag()
    }

    fun getAvailableLanguages(): List<String> {
        if (supportedLanguages.isEmpty()) {
            supportedLanguages =  tts.availableLanguages?.map { it.toLanguageTag() } ?: emptyList()
        }
        return supportedLanguages
    }

    fun getVoices(): List<String> {
        if (supportedVoices.isEmpty()){
            tts.voices.map { it.name }
        }
        return supportedVoices
    }

    fun getVoicesByLanguage(lang: String): List<String> {
        return tts.voices?.filter {
            it.locale.toLanguageTag() == lang
        }?.map { it.name } ?: emptyList()
    }

}