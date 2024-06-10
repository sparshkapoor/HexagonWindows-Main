//
//  ContentView.swift
//  HexagonWindows
//
//  Created by Sparsh Kapoor on 5/28/24.
//

import SwiftUI
import SceneKit
import WebKit

struct ContentView: View {
    @State private var selectedURL: URL? = nil
    @State private var selectedTab = 1
    @State private var isMenuCollapsed = false
    
    var body: some View {
        ZStack {
            if let url = selectedURL {
                WebViewScreen(url: url, onBack: {
                    selectedURL = nil
                })
            } else {
                VStack {
                    MenuScreen(selectedTab: $selectedTab, onSelectURL: { url in
                        selectedURL = url
                    })
                    .transition(.move(edge: .bottom))
                }
            }
        }
        .animation(.easeInOut)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
