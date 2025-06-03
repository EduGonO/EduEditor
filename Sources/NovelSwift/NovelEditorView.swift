import SwiftUI
import WebKit

public struct NovelEditorView: UIViewRepresentable {
    public init() {}

    public func makeUIView(context: Context) -> WKWebView {
        let cfg = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: cfg)

        if let url = Bundle.module.url(
            forResource: "index", withExtension: "html",
            subdirectory: "Web"
        ) {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        return webView
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {}
}