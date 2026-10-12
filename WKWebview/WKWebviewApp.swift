//
//  WKWebviewApp.swift
//  WKWebview
//  
//  Created by Evan Carlson on 6/20/23.
//

import SwiftUI
import Foundation
import Network

let staticFileServer: StaticFileServer = {
    let rootDirectory = Bundle.main.resourceURL?.appendingPathComponent("demo")
    if let dir = rootDirectory, FileManager.default.fileExists(atPath: dir.path) {
        let server = StaticFileServer(port: 8080, directory: dir)
        try? server.start()
        return server
    } else {
        print("Warning: demo folder not found in bundle. Static server will not serve files.")
        let fallback = Bundle.main.resourceURL!
        let server = StaticFileServer(port: 8080, directory: fallback)
        try? server.start()
        return server
    }
}()

@main
struct WKWebviewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
