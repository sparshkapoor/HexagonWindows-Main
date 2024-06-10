//
//  WebViewScreen.swift
//  HexagonWindows
//
//  Created by Sparsh Kapoor on 5/29/24.
//

import SwiftUI
import WebKit

struct WebViewScreen: View {
    let url: URL
    let onBack: () -> Void
    @State private var webView: WKWebView = WKWebView()
    @State private var zoomLevel: CGFloat = 1.0
    @State private var isMicButtonFocused = false
    @State private var showAiAssistView = false
    @State private var viewModel = ViewModels()
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    // Zoom in/out buttons on the complete left side
                    Button(action: {
                        zoomLevel += 0.15
                        applyZoom(webView: webView, zoomLevel: zoomLevel)
                    }) {
                        Text("+")
                            .padding()
                            .background(Color.clear)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .font(.title)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        zoomLevel = max(1.0, zoomLevel - 0.15)
                        applyZoom(webView: webView, zoomLevel: zoomLevel)
                    }) {
                        Text("-")
                            .padding()
                            .background(Color.clear)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .font(.title)
                    }
                    .padding(.horizontal)
                    
                }

                Spacer()

                // Mic button exactly in the center
                Button(action: {
                    showAiAssistView = true
                }) {
                    Image(systemName: "mic.fill")
                        .padding()
                        .background(Color.clear)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.title)
                }
                .padding(.horizontal)
                .buttonStyle(.plain)
                .onHover { hovering in
                    isMicButtonFocused = hovering
                }
                .sheet(isPresented: $showAiAssistView) {
                    AIAssistViewWrapper(viewModel: $viewModel, showAiAssistView: $showAiAssistView)
                        .frame(width: 400, height: 500) // Set the desired size of the window
                }
                Spacer()

                // Back button on the complete right corner
                Button(action: {
                    onBack()
                }) {
                    Text("Back")
                        .padding()
                        .background(Color.clear)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.title)
                }
                .padding(.horizontal)
            }
            .padding()
            
            WebViewWrapper(url: url, webView: $webView)
                .edgesIgnoringSafeArea(.all)
        }
    }

    func applyZoom(webView: WKWebView, zoomLevel: CGFloat) {
        let script = """
        document.body.style.transform = 'scale(\(zoomLevel))';
        document.body.style.transformOrigin = '0 0';
        document.body.style.width = '\(100 / zoomLevel)%';
        """
        webView.evaluateJavaScript(script, completionHandler: nil)
    }
}
