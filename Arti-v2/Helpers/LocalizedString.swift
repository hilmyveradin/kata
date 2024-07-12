//
//  LocalizedString.swift
//  Arti-v2
//
//  Created by Hilmy Veradin on 12/07/24.
//

import Foundation

enum LocalizedStrings {
    static let from = NSLocalizedString("From", comment: "")
    static let to = NSLocalizedString("To", comment: "")
    static let error = NSLocalizedString("Error", comment: "")

    static func languageName(_ language: SelectedLanguage) -> String {
        switch language {
        case .indonesia: return NSLocalizedString("Indonesian", comment: "")
        case .english: return NSLocalizedString("English", comment: "")
        case .chinese: return NSLocalizedString("Chinese", comment: "")
        case .spanish: return NSLocalizedString("Spanish", comment: "")
        case .germany: return NSLocalizedString("German", comment: "")
        case .french: return NSLocalizedString("French", comment: "")
        case .japanese: return NSLocalizedString("Japanese", comment: "")
        case .russian: return NSLocalizedString("Russian", comment: "")
        case .portugese: return NSLocalizedString("Portuguese", comment: "")
        case .hindi: return NSLocalizedString("Hindi", comment: "")
        }
    }

    static func startTranslating(for language: SelectedLanguage) -> String {
        switch language {
        case .indonesia: return NSLocalizedString("Mulai Menerjemahkan", comment: "")
        case .english: return NSLocalizedString("Start Translating", comment: "")
        case .chinese: return NSLocalizedString("开始翻译", comment: "")
        case .spanish: return NSLocalizedString("Empezar a traducir", comment: "")
        case .germany: return NSLocalizedString("Übersetzung starten", comment: "")
        case .french: return NSLocalizedString("Commencer la traduction", comment: "")
        case .japanese: return NSLocalizedString("翻訳を開始", comment: "")
        case .russian: return NSLocalizedString("Начать перевод", comment: "")
        case .portugese: return NSLocalizedString("Iniciar tradução", comment: "")
        case .hindi: return NSLocalizedString("अनुवाद शुरू करें", comment: "")
        }
    }

    static func listeningMessage(for language: SelectedLanguage) -> String {
        switch language {
        case .indonesia: return NSLocalizedString("Mendengarkan Kamu Bicara...", comment: "")
        case .english: return NSLocalizedString("Listening to you speak...", comment: "")
        case .chinese: return NSLocalizedString("正在听你说话...", comment: "")
        case .spanish: return NSLocalizedString("Escuchándote hablar...", comment: "")
        case .germany: return NSLocalizedString("Ich höre dir zu...", comment: "")
        case .french: return NSLocalizedString("En train de vous écouter...", comment: "")
        case .japanese: return NSLocalizedString("あなたの話を聞いています...", comment: "")
        case .russian: return NSLocalizedString("Слушаю вас...", comment: "")
        case .portugese: return NSLocalizedString("Ouvindo você falar...", comment: "")
        case .hindi: return NSLocalizedString("आपको सुन रहा हूँ...", comment: "")
        }
    }

    static func processingMessage(for language: SelectedLanguage) -> String {
        switch language {
        case .indonesia: return NSLocalizedString("Memproses Teks Kamu...", comment: "")
        case .english: return NSLocalizedString("Processing your text...", comment: "")
        case .chinese: return NSLocalizedString("正在处理你的文本...", comment: "")
        case .spanish: return NSLocalizedString("Procesando tu texto...", comment: "")
        case .germany: return NSLocalizedString("Verarbeite deinen Text...", comment: "")
        case .french: return NSLocalizedString("Traitement de votre texte...", comment: "")
        case .japanese: return NSLocalizedString("テキストを処理しています...", comment: "")
        case .russian: return NSLocalizedString("Обработка вашего текста...", comment: "")
        case .portugese: return NSLocalizedString("Processando seu texto...", comment: "")
        case .hindi: return NSLocalizedString("आपके टेक्स्ट को प्रोसेस कर रहा हूँ...", comment: "")
        }
    }

    static func translatedText(for language: SelectedLanguage) -> String {
        switch language {
        case .indonesia: return NSLocalizedString("Teks yang Diterjemahkan:", comment: "")
        case .english: return NSLocalizedString("Translated Text:", comment: "")
        case .chinese: return NSLocalizedString("翻译后的文本：", comment: "")
        case .spanish: return NSLocalizedString("Texto traducido:", comment: "")
        case .germany: return NSLocalizedString("Übersetzter Text:", comment: "")
        case .french: return NSLocalizedString("Texte traduit :", comment: "")
        case .japanese: return NSLocalizedString("翻訳されたテキスト：", comment: "")
        case .russian: return NSLocalizedString("Переведенный текст:", comment: "")
        case .portugese: return NSLocalizedString("Texto traduzido:", comment: "")
        case .hindi: return NSLocalizedString("अनुवादित टेक्स्ट:", comment: "")
        }
    }

    static func transcribedText(for language: SelectedLanguage) -> String {
        switch language {
        case .indonesia: return NSLocalizedString("Teks yang Ditranskripsikan:", comment: "")
        case .english: return NSLocalizedString("Transcribed Text:", comment: "")
        case .chinese: return NSLocalizedString("转录的文本：", comment: "")
        case .spanish: return NSLocalizedString("Texto transcrito:", comment: "")
        case .germany: return NSLocalizedString("Transkribierter Text:", comment: "")
        case .french: return NSLocalizedString("Texte transcrit :", comment: "")
        case .japanese: return NSLocalizedString("文字起こしされたテキスト：", comment: "")
        case .russian: return NSLocalizedString("Расшифрованный текст:", comment: "")
        case .portugese: return NSLocalizedString("Texto transcrito:", comment: "")
        case .hindi: return NSLocalizedString("प्रतिलेखित टेक्स्ट:", comment: "")
        }
    }
}
