//
//  MainTabView.swift
//  Arti-v2
//
//  Created by Hilmy Veradin on 12/07/24.
//

import SwiftUI
import AVFoundation

struct MainTabView: View {
    var body: some View {
        TabView {
            TranslateView()
                .tabItem {
                    Label("Translate", systemImage: "globe")
                }

            ChatBotView()
                .tabItem {
                    Label("Chat", systemImage: "message")
                }
        }
        .onAppear {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .measurement, options: [.mixWithOthers, .defaultToSpeaker])
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print("Failed to set up audio session: \(error)")
                return
            }
        }
    }
}

#Preview {
    MainTabView()
}
