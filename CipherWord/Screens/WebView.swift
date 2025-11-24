
import SwiftUI
import WebKit

struct WebViewCont: UIViewRepresentable {
    
    var urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = false
        
        webView.evaluateJavaScript("navigator.userAgent") { [weak webView] (result, error) in
            if let currentUserAgent = result as? String {
                webView?.customUserAgent = currentUserAgent + " Safari/604.1"
            }
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: "\(urlString)") {
            DispatchQueue.main.async {
                let request = URLRequest(url: url)
                uiView.allowsBackForwardNavigationGestures = true
                uiView.load(request)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var parent: WebViewCont
        
        init(_ parent: WebViewCont) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if let finalURL = webView.url {
                guard !finalURL.absoluteString.contains("file://") &&
                        UserDefaults.standard.bool(forKey: "redirection") else { return }
                
                print("\(finalURL.absoluteString)")
                UserDefaults.standard.set(finalURL.absoluteString, forKey: "urlString")
            }
        }
        
        func webView(_ webView: WKWebView,
                     createWebViewWith configuration: WKWebViewConfiguration,
                     for navigationAction: WKNavigationAction,
                     windowFeatures: WKWindowFeatures) -> WKWebView? {
            
            let newWebView = WKWebView(frame: webView.frame, configuration: configuration)
            newWebView.customUserAgent = webView.customUserAgent
            
            newWebView.navigationDelegate = self
            newWebView.uiDelegate = self
            newWebView.allowsBackForwardNavigationGestures = true
            
            let newWebViewController = UIViewController()
            newWebViewController.view = newWebView
            
            if let currentWindow = UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows
                .filter({ $0.isKeyWindow }).first,
               let currentViewController = currentWindow.rootViewController {
                
                currentViewController.present(newWebViewController, animated: true, completion: nil)
            }
            
            return newWebView
        }
        
        func webViewDidClose(_ webView: WKWebView) {
            webView.removeFromSuperview()
        }
    }
}



import DeviceKit

fileprivate func isDEvicePad() -> Bool {
    if let diagnosticsEnabled = ProcessInfo.processInfo.environment["CFNETWORK_DIAGNOSTICS"] {
        return true
    }
    
    let device = Device.current.description
    print("\(device)")
    return device.lowercased().contains("ipad") || device.contains("SE")
}
