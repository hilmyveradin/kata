//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Hilmy Veradin on 12/07/24.
//

import UIKit
import SwiftUI
import Combine

class KeyboardViewController: UIInputViewController {
    
    private let viewModel = KeyboardViewModel()
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hostingController = UIHostingController(rootView: KeyboardView(viewController: self, viewModel: viewModel))
        view.addSubview(hostingController.view)
        
        hostingController.view.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                      bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                      left: view.safeAreaLayoutGuide.leftAnchor,
                                      right: view.safeAreaLayoutGuide.rightAnchor, height: 300)
        
        // Add observer for isTextChanged
        viewModel.$isTextChanged.sink { [weak self] isChanged in
            if isChanged {
                self?.replaceSelectedTextWithTranslation()
            }
        }.store(in: &cancellables)
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        super.textDidChange(textInput)
        
        if let selectedText = textDocumentProxy.selectedText {
            viewModel.selectedText = selectedText
        }
    }
    
    private func replaceSelectedTextWithTranslation() {
        guard let documentCount = textDocumentProxy.selectedText?.count else {return}
        
        for _ in 0..<documentCount {
            textDocumentProxy.deleteBackward()
        }
        
        // Insert the translated text
        textDocumentProxy.insertText(viewModel.translatedText)
        
        // Toggle isTextChanged back to false
        viewModel.isTextChanged = false
    }
    
    private var cancellables = Set<AnyCancellable>()
}
