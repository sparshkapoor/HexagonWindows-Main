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
    @State private var isMicButtonFocused = false
    @State private var showAiAssistView = false
    @State private var showGoogleStreetView = false
    @State private var viewModel = ViewModels()

    var body: some View {
        VStack {
            HStack{
                Button(action: {
                    openWindow(id: "Menu")
                }) {
                    Image("Command Center Image")
                        .resizable()
                    //.background(Color.clear)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .glassBackgroundEffect()
                        .frame(width: 120, height: 120)
                }
                .padding(20)
                .navigationTitle("Command Center")
                .buttonStyle(.plain)
                .frame(width: 100, height: 100)
                Spacer()
                    .frame(minWidth: 100)
                Button(action: {
                    showAiAssistView = true
                }) {
                    Image(systemName: "mic.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .background(Color.clear)
                        .cornerRadius(10)
                        .animation(.easeInOut(duration: 0.2))
                        .frame(width: 120, height: 120)
                }
                .buttonStyle(.plain)
                .onHover { hovering in
                    isMicButtonFocused = hovering
                }
                .sheet(isPresented: $showAiAssistView) {
                    AIAssistViewWrapper(viewModel: $viewModel, showAiAssistView: $showAiAssistView)
                        .frame(width: 400, height: 500)
                }
                Spacer()
                    .frame(minWidth: 100)
                Button(action: {
                    showGoogleStreetView = true
                }) {
                    Image(systemName: "road.lanes")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .background(Color.clear)
                        .cornerRadius(10)
                        .animation(.easeInOut(duration: 0.2))
                        .frame(width: 120, height: 120)
                }
                .buttonStyle(.plain)
                .fullScreenCover(isPresented: $showGoogleStreetView) {
                    GoogleStreetViewWrapper(showGoogleStreetView: $showGoogleStreetView)
                }
            Spacer()
            }
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


struct AIAssistViewWrapper: View {
    @Binding var viewModel: ViewModels
    @Binding var showAiAssistView: Bool

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    showAiAssistView = false
                }) {
                    Text("Exit")
                        .padding()
                        .background(Color.clear)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            Spacer()
            AIAssistView(vm: viewModel)
            Spacer()
        }
        .onAppear {
            viewModel.startCaptureAudio()
        }
    }
}


struct GoogleStreetViewWrapper: View {
    @Binding var showGoogleStreetView: Bool

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    showGoogleStreetView = false
                }) {
                    Text("Exit")
                        .padding()
                        .background(Color.clear)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            Spacer()
            StreetVisionApp()
            Spacer()
                .frame(maxHeight: 20)
        }
        .frame(width: 1210, height: 720)
    }
}


struct OpenCmdCenter_Previews: PreviewProvider {
    static var previews: some View {
        OpenCmdCenter()
    }
}
