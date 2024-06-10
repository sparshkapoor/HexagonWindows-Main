//
//  MenuScreen.swift
//  HexagonWindows
//
//  Created by Sparsh Kapoor on 5/29/24.
//

import SwiftUI

struct MenuScreen: View {
    @Binding var selectedTab: Int
    var onSelectURL: (URL) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                MainScreen(buttons: page1Buttons, onSelectURL: onSelectURL)
                    .tag(0)
                    .tabItem {
                        Text("Page 1")
                    }
                MainScreen(buttons: page2Buttons, onSelectURL: onSelectURL)
                    .tag(1)
                    .tabItem {
                        Text("Page 2")
                    }
                MainScreen(buttons: page3Buttons, onSelectURL: onSelectURL)
                    .tag(2)
                    .tabItem {
                        Text("Page 3")
                    }
            }
            .tabViewStyle(PageTabViewStyle())
        }
    }
}
