//
//  TranslateView.swift
//  Arti-v2
//
//  Created by Hilmy Veradin on 12/07/24.
//

import SwiftUI

struct TranslateView: View {
    @StateObject private var viewModel = TranslateViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            switch viewModel.listeningState {
            case .noListening:
                languageSelectionView
                Spacer()
                startTranslatingButton
                Spacer()
            case .isListening:
                listeningText
            case .processingText:
                processingText
            case .endListening:
                if viewModel.finishSpeaking {
                    languageSelectionView
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                viewModel.resetStates()
                            }
                        }
                } else {
                    Rectangle()
                        .padding(.top, 48)
                        .frame(width: 1, height: 48)
                }
                translationResultView
                Spacer()
            case .errorListening:
                Text(LocalizedStrings.error)
            }
        }
        .padding()
    }
    
    private var languageSelectionView: some View {
        HStack {
            Spacer()
            languagePicker(for: $viewModel.languageOrigin)
            Text("→")
            languagePicker(for: $viewModel.languageDestination)
            Spacer()
        }
        .frame(height: 48)
        .padding(.top, 48)
    }
    
    private func languagePicker(for selection: Binding<SelectedLanguage>) -> some View {
            Picker("", selection: selection) {
                ForEach(SelectedLanguage.allCases, id: \.self) { language in
                    Text(LocalizedStrings.languageName(language)).tag(language)
                }
            }
            .onChange(of: selection.wrappedValue) {
                viewModel.resetStates()
            }

    }
    
    private var startTranslatingButton: some View {
        Button(action: {
            viewModel.startListeningState()
        }) {
            Text(LocalizedStrings.startTranslating(for: viewModel.languageOrigin))
                .font(.headline)
                .padding(96)
                .overlay(
                    Circle()
                        .stroke(Color.blue, lineWidth: 2)
                )
        }
    }
    
    private var listeningText: some View {
        Text(LocalizedStrings.listeningMessage(for: viewModel.languageOrigin))
    }
    
    private var processingText: some View {
        Text(LocalizedStrings.processingMessage(for: viewModel.languageOrigin))
    }
    
    private var translationResultView: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 16) {
                translatedTextView
                transcribedTextView
            }
        }
    }
    
    private var translatedTextView: some View {
        VStack(alignment: .center) {
            Text(LocalizedStrings.translatedText(for: viewModel.languageDestination))
                .font(.headline)
            Text(viewModel.translatedText ?? "")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
    }
    
    private var transcribedTextView: some View {
        VStack(alignment: .center) {
            Text(LocalizedStrings.transcribedText(for: viewModel.languageOrigin))
                .font(.headline)
            Text(viewModel.transcribedText ?? "")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
    }
}

#Preview {
    TranslateView()
}
