
import SwiftUI

struct ContentView: View {
    @State private var showOnboarding: Bool = false
    @State var showLoadingRobotikBALKON = true
    
    var body: some View {
        ZStack {
            ZStack {
                WelcomeView()
                
                if showOnboarding {
                    OnboardingView(isPresented: $showOnboarding)
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        showOnboarding = true
                    }
                }
            }
            
            LoadingView(showView: $showLoadingRobotikBALKON)
                .opacity(showLoadingRobotikBALKON ? 1: 0)
        }
    }
}

#Preview {
    ContentView()
}
