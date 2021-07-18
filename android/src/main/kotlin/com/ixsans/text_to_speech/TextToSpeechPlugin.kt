package com.ixsans.text_to_speech

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** TextToSpeechPlugin */
class TextToSpeechPlugin: FlutterPlugin, ActivityAware {
  private var tts: Tts? = null
  private var methodCallHandler: MethodCallHandlerImpl? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    tts = Tts(flutterPluginBinding.applicationContext)
    methodCallHandler = MethodCallHandlerImpl(tts!!)
    methodCallHandler!!.startListening(flutterPluginBinding.binaryMessenger)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    methodCallHandler?.stopListening()
    methodCallHandler = null
    tts = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {

  }

  override fun onDetachedFromActivityForConfigChanges() {

  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

  }

  override fun onDetachedFromActivity() {
  }
}
