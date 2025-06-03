import SwiftUI
import WebKit

public struct NovelEditorView: UIViewRepresentable {
    public init() {}

    public class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        public func userContentController(_ userContentController: WKUserContentController,
                                          didReceive message: WKScriptMessage) {
            if message.name == "consoleLog" {
                print("[WebView console] \(message.body)")
            }
        }

        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("[WebView] didFail navigation:", error)
        }
        public func webView(_ webView: WKWebView,
                            didFailProvisionalNavigation navigation: WKNavigation!,
                            withError error: Error) {
            print("[WebView] didFail provisional:", error)
        }
    }

    public func makeCoordinator() -> Coordinator { Coordinator() }

    public func makeUIView(context: Context) -> WKWebView {
        // 1) Print out resourceURL and its children
        if let resourceURL = Bundle.module.resourceURL {
            print("[Bundle.resourceURL] → \(resourceURL.path)")
            do {
                let contents = try FileManager.default.contentsOfDirectory(atPath: resourceURL.path)
                print("[Bundle.resourceURL children] → \(contents)")
            } catch {
                print("[Bundle] error listing resourceURL:", error)
            }
        } else {
            print("[Bundle] ❌ resourceURL is nil")
        }

        // 2) Then try locating index.html
        let htmlURL = Bundle.module.url(
            forResource: "index",
            withExtension: "html",
            subdirectory: "Web"
        )
        if let url = htmlURL {
            print("[Bundle] Found index.html at → \(url.path)")
        } else {
            print("[Bundle] ❌ index.html not found in subdirectory 'Web'")
        }

        // 3) Create and configure the web view
        let userController = WKUserContentController()
        userController.add(context.coordinator, name: "consoleLog")
        let js = """
        (function() {
          const origLog = console.log;
          console.log = function(...args) {
            window.webkit.messageHandlers.consoleLog.postMessage(args.join(' '));
            origLog.apply(console, args);
          };
        })();
        """
        userController.addUserScript(
            WKUserScript(source: js,
                         injectionTime: .atDocumentStart,
                         forMainFrameOnly: false)
        )

        let config = WKWebViewConfiguration()
        config.userContentController = userController

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator

        // 4) Actually try to load index.html
        if let url = htmlURL {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
            print("[WebView] 🚀 Loading index.html → \(url.path)")
        } else {
            print("[WebView] ❌ index.html not found in bundle; cannot load WebView")
        }

        return webView
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {}
}