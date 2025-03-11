import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    let htmlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        DispatchQueue.main.async {
            webView.loadHTMLString(htmlString, baseURL: nil)
        }
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        DispatchQueue.main.async {
            webView.loadHTMLString(htmlString, baseURL: nil)
        }
    }
}
