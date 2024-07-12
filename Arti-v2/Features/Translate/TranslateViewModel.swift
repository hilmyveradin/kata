//
//  TranslateViewModel.swift
//  Arti-v2
//
//  Created by Hilmy Veradin on 12/07/24.
//

import SwiftUI
import Speech
import AVFoundation
import NaturalLanguage

enum SelectedLanguage: String, CaseIterable, Identifiable {
    case indonesia
    case english
    case chinese
    case spanish
    case germany
    case french
    case japanese
    case russian
    case portugese
    case hindi
    var id: Self { self }
}

enum ListeningState {
    case noListening
    case isListening
    case processingText
    case endListening
    case errorListening
}

class TranslateViewModel: NSObject,ObservableObject, AVSpeechSynthesizerDelegate {
    @Published var languageOrigin: SelectedLanguage = .indonesia {
        didSet {
            updateSpeechRecognizer()
        }
    }
    @Published var languageDestination: SelectedLanguage = .english {
        didSet {
            updateSpeechRecognizer()
        }
    }
    @Published var listeningState: ListeningState = .noListening
    @Published var transcribedText: String? = nil
    @Published var translatedText: String? = nil
    @Published var finishSpeaking = false
    
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    private var silenceTimer: Timer?
    private let openAIService = OpenAIService()
    private var lastSpeechTimeStamp: Date?
    private var initiateSpeechTimeStamp: Date?
    
    private var isTranslating = false // Flag to prevent multiple translations
    
    override init() {
        super.init()
        updateSpeechRecognizer()
        synthesizer.delegate = self
    }
    
    func updateSpeechRecognizer() {
        var identifier: String
        
        switch languageOrigin {
        case .indonesia:
            identifier = "id-ID"
        case .english:
            identifier = "en-UK"
        case .chinese:
            identifier = "zh-CN"
        case .spanish:
            identifier = "es-ES"
        case .germany:
            identifier = "de-DE"
        case .french:
            identifier = "fr-FR"
        case .japanese:
            identifier = "ja-JP"
        case .russian:
            identifier = "ru-RU"
        case .portugese:
            identifier = "pt-PT"
        case .hindi:
            identifier = "hi-IN"
        }
        
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: identifier))
    }
    
    func startListeningState() {
        startListening()
    }
    
    func resetStates() {
        finishSpeaking = false
        listeningState = .noListening
        isTranslating = false
        transcribedText = nil
        translatedText = nil
        lastSpeechTimeStamp = nil
    }
    
    private func startListening() {
        
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            print("Speech recognition is not available")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .measurement, options: [.mixWithOthers, .defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to set up audio session: \(error)")
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        // Remove any existing taps
        inputNode.removeTap(onBus: 0)
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        guard let recognitionRequest = recognitionRequest else {
            print("Unable to create recognition request")
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) {
            [weak self] result, error in
            guard let self = self else { return }
            
            self.lastSpeechTimeStamp = Date()
            
            if let result = result {
                let newText = result.bestTranscription.formattedString
                print(newText)
                if newText != self.transcribedText {
                    self.initiateSpeechTimeStamp = nil
                    self.transcribedText = newText
                    self.lastSpeechTimeStamp = Date()
                    print("new text: \(newText)")
                    self.resetSilenceTimer()
                }
            }
            
            if error != nil {
                self.stopListening()
            }
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            lastSpeechTimeStamp = Date()
            initiateSpeechTimeStamp = Date()
            listeningState = .isListening
            resetSilenceTimer()
        } catch {
            print("Failed to start audio engine: \(error)")
            return
        }
    }
    
    private func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        silenceTimer?.invalidate()
        silenceTimer = nil
        
        listeningState = .processingText
        
        lastSpeechTimeStamp = nil
        // Trigger translation after stopping
        
        if !isTranslating {
            translate()
        }
        
    }
    
    private func resetSilenceTimer() {
        silenceTimer?.invalidate()
        silenceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            guard let lastSpeech = self.lastSpeechTimeStamp else { return }
            
            if let initiateSpeechTimeStamp = initiateSpeechTimeStamp {
                if Date().timeIntervalSince(initiateSpeechTimeStamp) >= 5 {
                    self.resetStates()
                }
            } else {
                if Date().timeIntervalSince(lastSpeech) >= 1 {
                    print("time interval called")
                    self.stopListening()
                    
                }
            }
        }
    }
    
    private func translate() {
        isTranslating = true
        openAIService.translate(text: transcribedText, origin: languageOrigin, destination: languageDestination) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let translatedText):
                    let tempOrigin = self.languageOrigin
                    self.languageOrigin = self.languageDestination
                    self.languageDestination = tempOrigin
                    self.listeningState = .endListening
                    self.translatedText = translatedText
                    self.speakTranslatedText(translatedText)
                case .failure(_):
                    self.listeningState = .noListening
                }
            }
        }
    }
    
    private func speakTranslatedText(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        if let language = self.detectLanguageOf(text: text) {
            utterance.voice = AVSpeechSynthesisVoice(language: language.rawValue)
        }
        
        synthesizer.speak(utterance)
    }
    
    private func detectLanguageOf(text: String) -> NLLanguage? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        
        guard let language = recognizer.dominantLanguage else {
            return nil
        }
        
        return language
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        finishSpeaking = true
        
    }
}
