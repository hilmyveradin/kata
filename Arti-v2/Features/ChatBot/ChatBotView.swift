//
//  ChatBotView.swift
//  Arti-v2
//
//  Created by Hilmy Veradin on 12/07/24.
//

import SwiftUI

struct ChatBotView: View {
    @StateObject private var viewModel = ChatbotViewModel()
    @FocusState private var textFieldFocused: Bool


    var body: some View {
        VStack {
            Picker("", selection: $viewModel.selectedLanguage) {
                ForEach(SelectedLanguage.allCases) { language in
                    Text(language.rawValue.capitalized).tag(language)
                }
            }
            .padding(.top, 24)

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.messages) { message in
                        ChatBubbleView(message: message, speakAction: {
                            viewModel.speakMessage(message.content)
                        })
                    }
                }
            }

            HStack {
                TextField("Type a message", text: $viewModel.userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($textFieldFocused)

                Button {
                    viewModel.sendMessage()
                    textFieldFocused = false
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.horizontal, 2)
                    } else {
                        Image(systemName: "paperplane.fill")
                    }
                    
                }

            }
        .allowsHitTesting(!viewModel.isLoading)
            .padding()
        }
    }

    private var languageSelectionView: some View {
        HStack {
            languagePicker(for: $viewModel.selectedLanguage)
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
}

struct ChatBubbleView: View {
    let message: ChatMessage
    let speakAction: () -> Void

    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            VStack(alignment: .leading, spacing: 6) {
                Text(message.content)
                    .padding()
                    .background(message.isUser ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                Button(action: speakAction) {
                    Image(systemName: "speaker.wave.2.fill")
                }
                .padding(.leading)
            }

            if !message.isUser { Spacer() }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ChatBotView()
}
