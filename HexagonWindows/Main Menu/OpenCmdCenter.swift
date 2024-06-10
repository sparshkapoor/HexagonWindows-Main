//
//  OpenCmdCenter.swift
//  HexagonWindows
//
//  Created by workmerkdev on 6/3/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct OpenCmdCenter: View {
    @Environment(\.openWindow) private var openWindow
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    
    var body: some View {
        VStack {
            Button(action: {
                openWindow(id: "Menu")
            }) {
                Text("Open Command Center")
                    .padding(24)
                    //.background(Color.clear)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .glassBackgroundEffect()
            }
            .padding(20)
            .navigationTitle("Command Center")
            .buttonStyle(.plain)
            .frame(width: 300, height: 100)
            Toggle("Base View", isOn: $showImmersiveSpace)
                .background(Color.clear)
                .foregroundColor(.white)
                .padding(24)
                .glassBackgroundEffect()
        }   .padding()
            .frame(width:300, height:100)
             .onChange(of: showImmersiveSpace) { _, newValue in
                Task {
                    if newValue {
                        switch await openImmersiveSpace(id: "ImmersiveSpace") {
                        case .opened:
                            immersiveSpaceIsShown = true
                        case .error, .userCancelled:
                            fallthrough
                        @unknown default:
                            immersiveSpaceIsShown = false
                            showImmersiveSpace = false
                        }
                    } else if immersiveSpaceIsShown {
                        await dismissImmersiveSpace()
                        immersiveSpaceIsShown = false
                    }
                }
            }
        
    }
}

struct OpenCmdCenter_Previews: PreviewProvider {
    static var previews: some View {
        OpenCmdCenter()
    }
}
