import Cocoa
import FlutterMacOS

public class TextToSpeechPlugin: NSObject, FlutterPlugin {
  let tts = Tts()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "dev.ixsans/text_to_speech", binaryMessenger: registrar.messenger)
    let instance = TextToSpeechPlugin()
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
                result(FlutterMethodNotImplemented)
        }
    }

    func speak(_ text: String) {
        tts.speak(text)
    }
    func stop() -> Bool {
        return tts.stop()
    }

    func pause() -> Bool {
        return tts.pause()
    }

    func resume() -> Bool {
        return tts.resume()
    }

    func setRate(_ rate: Float) {
        tts.setRate(rate * 0.5)
    }

    func setVolume(_ volume: Float) {
        tts.setVolume(volume)
    }

    func setPitch(_ pitch: Float) {
        tts.setPitch(pitch)
    }

    func setLanguage(_ lang: String) {
        tts.setLanguage(lang)
    }

    func setVoice(_ voice: String) {
        tts.setVoice(voice)
    }

    func getLanguages()-> [String]{
        return tts.getLanguages()
    }

    func getDefaultLanguage() -> String {
        return tts.getDefaultLanguage()
    }

    func getVoices()-> [String] {
        return tts.getVoices()
    }

    func getVoiceByLanguage(_ lang: String)-> [String] {
          return tts.getVoiceByLanguage(lang)
    }

    func getDefaultVoice() -> String? {
        return tts.getDefaultVoice()
    }
}
