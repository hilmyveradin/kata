//
//  ContentView.swift
//  Arti-v2
//
//  Created by Hilmy Veradin on 12/07/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            TranslateView()
                .tabItem {
                    Label("Translate", systemImage: "globe")
                }
        }
    }
}

#Preview {
    MainTabView()
}
