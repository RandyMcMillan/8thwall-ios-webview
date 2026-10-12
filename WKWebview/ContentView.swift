//
//  ContentView.swift
//  WKWebview
//
//  Created by Evan Carlson on 6/20/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            WebView(url: URL(string: "https://apple.com")!)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
