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
            
            Button(action: {
                viewModel.translate()
            }, label: {
                Text("translate")
            })
            
            if viewModel.isTextChanged {
                Button(action: {
                    viewModel.isTextChanged.toggle()
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
