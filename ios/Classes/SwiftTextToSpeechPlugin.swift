import Flutter
import UIKit

public class SwiftTextToSpeechPlugin: NSObject, FlutterPlugin {
   let textToSpeech = TextToSpeech()

     public static func register(with registrar: FlutterPluginRegistrar) {
       let channel = FlutterMethodChannel(name: "dev.ixsans/text_to_speech", binaryMessenger: registrar.messenger())
       let instance = SwiftTextToSpeechPlugin()
       registrar.addMethodCallDelegate(instance, channel: channel)
     }

     public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
       switch call.method {
           case "speak":
               let args = call.arguments as! NSDictionary
               let text = args["text"] as! String
               speak(text)
           case "stop":
               result(stop())
           case "pause":
               result(pause())
           case "resume":
               result(resume())
           case "setVolume":
               let args = call.arguments as! NSDictionary
               let volume = args["volume"] as! Double
               setVolume(Float(volume))
           case "setRate":
               let args = call.arguments as! NSDictionary
               let rate = args["rate"] as! Double
               setRate(Float(rate))
           case "setPitch":
               let args = call.arguments as! NSDictionary
               let pitch = args["pitch"] as! Double
               setPitch(Float(pitch))
           case "setLanguage":
               let args = call.arguments as! NSDictionary
               let lang = args["lang"] as! String
               setLanguage(lang)
           case "setVoice":
               let args = call.arguments as! NSDictionary
               let voice = args["voice"] as! String
               setVoice(voice)
           case "getLanguages":
               result(getLanguages())
           case "getDefaultLanguage":
               result(getDefaultLanguage())
           case "getVoices":
               result(getVoices())
           case "getVoiceByLanguage":
               let args = call.arguments as! NSDictionary
               let lang = args["lang"] as! String
               result(getVoiceByLanguage(lang))
           case "getDefaultVoice":
               result(getDefaultVoice())
           default:
               break
       }
     }

       func speak(_ text: String) {
           textToSpeech.speak(text)
       }

       func stop() -> Bool{
           textToSpeech.stop()
       }

       func pause() -> Bool {
           textToSpeech.pause()
       }

       func resume() -> Bool {
           textToSpeech.resume()
       }

       func setRate(_ rate: Float) {
           textToSpeech.setRate(rate * 0.5)
       }

       func setVolume(_ volume: Float) {
           textToSpeech.setVolume(volume)
       }

       func setPitch(_ pitch: Float) {
           textToSpeech.setPitch(pitch)
       }

       func setLanguage(_ lang: String) {
           textToSpeech.setLanguage(lang)
       }


       func setVoice(_ voice: String) {
           textToSpeech.setVoice(voice)
       }

       func getLanguages()-> [String]{
           return textToSpeech.getLanguages()
       }


       func getDefaultLanguage() -> String {
           return textToSpeech.getDefaultLanguage()
       }

       func getVoices()-> [String] {
           return textToSpeech.getVoices()
       }

       func getVoiceByLanguage(_ lang: String)-> [String] {
           return textToSpeech.getVoiceByLanguage(lang)
       }

       func getDefaultVoice() -> String? {
           return textToSpeech.getDefaultVoice()
       }
}
