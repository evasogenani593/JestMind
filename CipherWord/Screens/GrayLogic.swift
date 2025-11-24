
import Foundation

class GrayLogic {
    var grayLink: String
    
    
    init(grayLink: String) {
        self.grayLink = grayLink
        var urlString = UserDefaults.standard.string(forKey: "urlString")
        
        if urlString == nil || (urlString ?? "").isEmpty {
                let urlString = grayLink
                    UserDefaults.standard.set(grayLink, forKey: "urlString")
        }
    }
}

private class RedirectHandler: NSObject, URLSessionDelegate, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(request)
    }
}
