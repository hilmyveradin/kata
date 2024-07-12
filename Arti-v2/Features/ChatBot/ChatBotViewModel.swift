//
//  ChatBotViewModel.swift
//  Arti-v2
//
//  Created by Hilmy Veradin on 12/07/24.
//

import AVFoundation
import SwiftUI
import NaturalLanguage

struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
}

class ChatbotViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var userInput: String = ""
    @Published var selectedLanguage: SelectedLanguage = .english {
        didSet {
            updateGreetingMessage()
        }
    }

    @Published var isQuizMode: Bool = false
    @Published var isLoading: Bool = false

    init() {
        updateGreetingMessage() // Call this in the initializer to set the initial message
    }

    private let openAIService = OpenAIService()
    private let speechSynthesizer = AVSpeechSynthesizer()

    func sendMessage() {
        isLoading = true
        let userMessage = ChatMessage(content: userInput, isUser: true)
        messages.append(userMessage)

        let apiMessages = messages.map { Message(role: $0.isUser ? "user" : "assistant", content: $0.content) }

        openAIService.chatbotInteraction(messages: apiMessages, selectedLanguage: selectedLanguage) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    let botMessage = ChatMessage(content: response, isUser: false)
                    self?.messages.append(botMessage)

                    if self?.isQuizMode == false {
                        self?.checkForQuizTrigger(in: response)
                    }
                    
                    self?.isLoading = false
                case let .failure(error):
                    print("Error: \(error.localizedDescription)")
                    // Handle error (e.g., show an alert to the user)
                }
            }
        }

        userInput = ""
    }
    
    func speakMessage(_ message: String) {
        speechSynthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: message)
        let languageCode = self.languageCode(for: selectedLanguage)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        speechSynthesizer.speak(utterance)
    }

    private func detectLanguageOf(text: String) -> NLLanguage? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)

        guard let language = recognizer.dominantLanguage else {
            return nil
        }

        return language
    }

    func resetStates() {
        messages = []
        userInput = ""
    }

    private func checkForQuizTrigger(in response: String) {
        if response.lowercased().contains("quiz") {
            isQuizMode = true
        }
    }

    private func languageCode(for language: SelectedLanguage) -> String {
        switch language {
        case .indonesia:
            return "id-ID"
        case .english:
            return "en-UK"
        case .chinese:
            return "zh-CN"
        case .spanish:
            return "es-ES"
        case .germany:
            return "de-DE"
        case .french:
            return "fr-FR"
        case .japanese:
            return "ja-JP"
        case .russian:
            return "ru-RU"
        case .portugese:
            return "pt-PT"
        case .hindi:
            return "hi-IN"
        }
    }

    private func updateGreetingMessage() {
        let content: String
        switch selectedLanguage {
        case .indonesia:
            content = "Saya adalah asisten belajar Anda. Ingin belajar apa hari ini?\n"
        case .english:
            content = "I'm your learning assistant. What do you want to learn today?\n----------\nSaya adalah asisten belajar Anda. Ingin belajar apa hari ini?\n"
        case .chinese:
            content = "我是你的学习助手。你今天想学什么？\n----------\nSaya adalah asisten belajar Anda. Ingin belajar apa hari ini?\n"
        case .spanish:
            content = "Soy tu asistente de aprendizaje. ¿Qué quieres aprender hoy?\n----------\nSaya adalah asisten belajar Anda. Ingin belajar apa hari ini?\n"
        case .germany:
            content = "Ich bin dein Lernassistent. Was möchtest du heute lernen?\n----------\nSaya adalah asisten belajar Anda. Ingin belajar apa hari ini?\n"
        case .french:
            content = "Je suis votre assistant d'apprentissage. Que souhaitez-vous apprendre aujourd'hui ?\n----------\nSaya adalah asisten belajar Anda. Ingin belajar apa hari ini?\n"
        case .japanese:
            content = "私はあなたの学習アシスタントです。今日は何を学びたいですか？\n----------\nSaya adalah asisten belajar Anda. Ingin belajar apa hari ini?\n"
        case .russian:
            content = "Я ваш помощник в обучении. Что вы хотите изучать сегодня?\n----------\nSaya adalah asisten belajar Anda. Ingin belajar apa hari ini?\n"
        case .portugese:
            content = "Eu sou seu assistente de aprendizagem. O que você quer aprender hoje?\n----------\nSaya adalah asisten belajar Anda. Ingin belajar apa hari ini?\n"
        case .hindi:
            content = "मैं आपका सीखने का सहायक हूँ। आप आज क्या सीखना चाहते हैं?\n----------\nSaya adalah asisten belajar Anda. Ingin belajar apa hari ini?\n"
        }

        messages = []
        messages.insert(ChatMessage(content: content, isUser: false), at: 0)
    }
}
