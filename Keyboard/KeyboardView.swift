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

        VStack(spacing: 8) {
            if (viewModel.isLoading) {
                ProgressView()
            } else {
                Spacer()

                Picker("", selection: $viewModel.destinationLanguage) {
                    ForEach(SelectedLanguage.allCases) { language in
                        Text(LocalizedStrings.languageName(language)).tag(language)
                    }
                }
                .onChange(of: viewModel.destinationLanguage) {
                    viewModel.resetStates()
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.translate()
                }, label: {
                    Text("Translate")
                })
                .padding()
                .tint(.gray)
                .buttonStyle(.borderedProminent)
                
                Button(action: {
                    viewModel.fixGrammar()
                }, label: {
                    Text("Fix Grammar")
                })
                .padding()
                .tint(.gray)
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            
            
        }
    }
}

#Preview {
    KeyboardView(viewController: KeyboardViewController(nibName: nil, bundle: nil), viewModel: KeyboardViewModel())
}
