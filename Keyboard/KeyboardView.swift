//
//  KeyboardView.swift
//  Keyboard
//
//  Created by Hilmy Veradin on 12/07/24.
//

import SwiftUI

struct KeyboardView: View {
    var viewController: KeyboardViewController
    
    @ObservedObject var viewModel: KeyboardViewModel
    
    var body: some View {
        VStack {
            
            Text(
                viewModel.translatedText)
                .background(Color.blue)
                .padding()
            
            Picker("", selection: $viewModel.destinationLanguage) {
                            ForEach(SelectedLanguage.allCases) { language in
                                Text(LocalizedStrings.languageName(language)).tag(language)
                            }
                        }
                        .onChange(of: viewModel.destinationLanguage) {
                            viewModel.resetStates()
                        }
            
            Button(action: {
                viewModel.translate()
            }, label: {
                Text("Translate")
            })
            
            if viewModel.translatedText != "" {
                Button(action: {
                    viewModel.isTextChanged = true
                }, label: {
                    Text("Change texts")
                })
            }

        }
    }
}

#Preview {
    KeyboardView(viewController: KeyboardViewController(nibName: nil, bundle: nil), viewModel: KeyboardViewModel())
}
