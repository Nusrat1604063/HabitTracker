//
//  VideoWebView.swift
//  HabitTracker
//
//  Created by Tabassum Akter Nusrat on 23/4/25.
//

import SwiftUI
import WebKit

struct VideoWebView: UIViewRepresentable {
    let videoURL: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: videoURL)
        uiView.load(request)
    }
}


#Preview {
    VideoWebView(videoURL: URL(string: "https://www.youtube.com/watch?v=AHl-QCsMgos")!)
}

