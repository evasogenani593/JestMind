
import SwiftUI

struct LoadingView: View {
    @AppStorage("firstInApp") var firstInApp = true
    @AppStorage("urlString") var urlString = ""
    
    @Binding var showView: Bool
    @State var rotation: CGFloat = 0
    
    var body: some View {
        ZStack {
            VStack {

            }
            if urlString != "error" && urlString != "" {
                webView(url: urlString)
            }
        }.onChange(of: urlString) { _ in
            skipLoadingView(withTime: 1)
        }
        .onAppear {
            guard !firstInApp else { return }
            skipLoadingView(withTime: 3)
        }
    }
    
    func skipLoadingView(withTime time: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(time)) {
            guard urlString == "error" else { return }
            AppDelegate.orientationLock = .portrait
            firstInApp = false
            withAnimation {
                showView = false   
            }
        }
    }
    
    func webView(url: String) -> some View {
        WebViewCont(urlString: url)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .padding(.top, 7)
            .padding(.bottom,  1)
            .background(Color.black)
    }
}

#Preview {
    LoadingView(showView: .constant(true))
}
