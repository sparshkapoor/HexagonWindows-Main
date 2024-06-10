//
//  WebViewWrapper.swift
//  HexagonWindows
//
//  Created by Sparsh Kapoor on 5/29/24.
//

import SwiftUI
import WebKit

struct WebViewWrapper: UIViewRepresentable {
    let url: URL
    @Binding var webView: WKWebView

    func makeUIView(context: Context) -> WKWebView {
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Optionally update the view if necessary
    }
}
