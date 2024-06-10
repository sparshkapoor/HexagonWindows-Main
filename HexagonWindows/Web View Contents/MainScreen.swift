//
//  MainScreen.swift
//  HexagonWindows
//
//  Created by Sparsh Kapoor on 5/29/24.
//

import SwiftUI

struct MainScreen: View {
    let buttons: [ButtonDetails]
    var onSelectURL: (URL) -> Void
    @State private var isMicButtonFocused = false
    @State private var showAiAssistView = false
    @State private var showGoogleStreetView = false
    @State private var viewModel = ViewModels()

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(spacing: 0.2) { // Reduce spacing to bring buttons closer
                    Spacer()
                    VStack(spacing: 0.2) { // Reduce spacing to bring buttons closer
                        ButtonView(buttonDetails: buttons[0], onSelectURL: onSelectURL)
                            .frame(width: geometry.size.width * 0.28, height: geometry.size.width * 0.28)
                        
                        ButtonView(buttonDetails: buttons[2], onSelectURL: onSelectURL)
                            .frame(width: geometry.size.width * 0.28, height: geometry.size.width * 0.28)
                    }
                    Spacer()
                    VStack(spacing: 0.2) { // Reduce spacing to bring buttons closer
                        ButtonView(buttonDetails: buttons[1], onSelectURL: onSelectURL)
                            .frame(width: geometry.size.width * 0.28, height: geometry.size.width * 0.28)
                        
                        ButtonView(buttonDetails: buttons[3], onSelectURL: onSelectURL)
                            .frame(width: geometry.size.width * 0.28, height: geometry.size.width * 0.28)
                    }
                    Spacer()
                }
                .overlay(
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                showAiAssistView = true
                            }) {
                                Image(systemName: "mic.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.05, height: geometry.size.width * 0.05)
                                    .foregroundColor(.white)
                                    .background(Color.clear)
                                    .cornerRadius(10)
                                    .animation(.easeInOut(duration: 0.2))
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
                                .frame(maxWidth: 50)
                            Button(action: {
                                showGoogleStreetView = true
                            }) {
                                Image(systemName: "road.lanes")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.05, height: geometry.size.width * 0.05)
                                    .foregroundColor(.white)
                                    .background(Color.clear)
                                    .cornerRadius(10)
                                    .animation(.easeInOut(duration: 0.2))
                            }
                            .buttonStyle(.plain)
                            .fullScreenCover(isPresented: $showGoogleStreetView) {
                                GoogleStreetViewWrapper(showGoogleStreetView: $showGoogleStreetView)
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                )
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.clear)
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










