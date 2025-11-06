
import SwiftUI

struct ContentView: View {
    @State private var showOnboarding: Bool = false
    
    var body: some View {
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
    }
}

#Preview {
    ContentView()
}
