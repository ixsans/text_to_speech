import AVKit

class Tts : NSObject {

    let speechSynthesizer = AVSpeechSynthesizer()

    var pitch: Float = 1 //[0.5 - 2] Default = 1
    var volume: Float = 1 // [0-1] Default = 1
    var rate: Float = AVSpeechUtteranceDefaultSpeechRate // 0-1
    var language: String?
    var voice: AVSpeechSynthesisVoice?
    
    func speak(_ text: String) {
        speechSynthesizer.stopSpeaking(at: .immediate)

        let utterance = AVSpeechUtterance(string: text)
        
        // set voice - language
        if (voice != nil) {
            utterance.voice = voice
        }else {
            if (language != nil) {
                utterance.voice = AVSpeechSynthesisVoice(language: language)
            }else {
                guard #available(iOS 11, *) else {
                    print("NSLinguisticTagger.dominantLanguage only availbe for iOS 11 or greater version")
                    return
                }
                let predicetedLang = NSLinguisticTagger.dominantLanguage(for: text)
                utterance.voice = AVSpeechSynthesisVoice(language: predicetedLang)
            }
        }
        
        // set rate
        utterance.rate = rate
        
        // set volume
        utterance.volume = volume
        
        // set pitch
        utterance.pitchMultiplier = pitch

        speechSynthesizer.speak(utterance)

    }

    func stop() -> Bool {
        return speechSynthesizer.stopSpeaking(at: .immediate)
    }
    
    func pause() -> Bool {
        return speechSynthesizer.pauseSpeaking(at: .immediate)
    }

    func resume() -> Bool {
        return speechSynthesizer.continueSpeaking()
    }
    
    func setRate(_ rate: Float) {
        self.rate = rate
    }
    
    func setVolume(_ volume: Float) {
        self.volume = volume
    }
    
    func setPitch(_ pitch: Float) {
        self.pitch = pitch
    }
    
    func setLanguage(_ lang: String) {
        self.language = lang;
    }

    func setVoice(_ voiceName: String) {
        if let selectedVoice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.name == voiceName}) {
            self.voice = selectedVoice
        }
    }

    
    func getLanguages()-> [String]{
        let voices = AVSpeechSynthesisVoice.speechVoices()
        let voicesSet =  Set(voices.map { $0.language})
        return Array(voicesSet)
    }

    func getDefaultLanguage() -> String {
        return AVSpeechSynthesisVoice.currentLanguageCode()
    }
    
    func getVoices()-> [String] {
        let voices = AVSpeechSynthesisVoice.speechVoices()
        return voices.map { $0.name}
    }

    func getVoiceByLanguage(_ lang: String) -> [String] {
        let voices = AVSpeechSynthesisVoice.speechVoices()
        return voices.filter{ $0.language == lang }.map { $0.name }
    }
    
    func getDefaultVoice() -> String? {
        let voice =  AVSpeechSynthesisVoice.init(language: getDefaultLanguage())
        return voice?.name
    }

}
