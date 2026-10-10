#if canImport(AppKit)
import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    let url: URL

    class Coordinator: NSObject, WKUIDelegate {
        var parent: WebView
        init(_ parent: WebView) { self.parent = parent }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = context.coordinator
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        // Implement if needed
    }
}
#endif

#if canImport(UIKit)
//
//  BrowserView.swift
//  WKWebview
//
//  Created by Evan Carlson on 6/20/23.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    let url: URL
    
    class Coordinator: NSObject, WKUIDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true

        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = context.coordinator
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}

#endif

