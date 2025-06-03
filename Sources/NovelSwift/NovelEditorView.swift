import SwiftUI
import WebKit

public struct NovelEditorView: UIViewRepresentable {
    public init() {}

    public class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        public func userContentController(_ userContentController: WKUserContentController,
                                          didReceive message: WKScriptMessage) {
            if message.name == "consoleLog" {
                print("[WebView console] \(message.body)")
            }
        }

        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("[WebView] didFail navigation:", error)
        }
        public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!,
                            withError error: Error) {
            print("[WebView] didFail provisional:", error)
        }
    }

    public func makeCoordinator() -> Coordinator { Coordinator() }

    public func makeUIView(context: Context) -> WKWebView {
        let userController = WKUserContentController()
        userController.add(context.coordinator, name: "consoleLog")

        // Inject a script to override console.log → window.webkit.messageHandlers.consoleLog.postMessage(...)
        let js = """
        (function() {
          const origLog = console.log;
          console.log = function(...args) {
            window.webkit.messageHandlers.consoleLog.postMessage(args.join(' '));
            origLog.apply(console, args);
          };
        })();
        """
        let script = WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        userController.addUserScript(script)

        let config = WKWebViewConfiguration()
        config.userContentController = userController

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator

        // Load index.html from the bundle
        if let url = Bundle.module.url(forResource: "index", withExtension: "html", subdirectory: "Web") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        } else {
            print("[WebView] ❌ index.html not found in bundle ")
        }
        return webView
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {}
}