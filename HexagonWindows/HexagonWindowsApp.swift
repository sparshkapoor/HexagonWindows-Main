//
//  HexagonWindowsApp.swift
//  HexagonWindows
//
//  Created by Sparsh Kapoor on 5/28/24.
//

import SwiftUI
import SceneKit
import WebKit

@main
struct HexagonWindows: App {
    @State private var isCommandCenterOpen = false
    var body: some Scene {
        WindowGroup {
            OpenCmdCenter()
                .background(Color.clear)
                .frame(width: 500, height: 200)
                } .windowStyle(.plain)
                  .defaultSize(CGSize(width: 400, height: 200))
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
        .immersionStyle(selection: .constant(.full), in: .mixed)
        
        ImmersiveSpace(id: "StreetView") {
            StreetViewImmersive()
        }
        .immersionStyle(selection: .constant(.full), in: .full)
        
        WindowGroup("Menu", id: "Menu") {
            ContentView()
                .background(Color.clear)
        }
        .defaultSize(width: 0.2, height: 0.2, depth: 0.2, in: .meters)
        .windowResizability(.contentSize)
    }
}

struct WindowsAppPreviews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


