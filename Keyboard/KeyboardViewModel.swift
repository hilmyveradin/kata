//
//  KeyboardViewModel.swift
//  Keyboard
//
//  Created by Hilmy Veradin on 12/07/24.
//

import Foundation

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

final class KeyboardViewModel: ObservableObject {
    private let openAIService = OpenAIService()
    @Published var translatedText = ""
    @Published var selectedText = ""
    @Published var isTextChanged = false
    @Published var destinationLanguage: SelectedLanguage = .english
    
    func translate() {
        openAIService.translate(text: translatedText, destination: destinationLanguage) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let translatedText):
                    self.translatedText = translatedText
                case .failure(_):
                    break
                }
            }
        }
    }
    
}
