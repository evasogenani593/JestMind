
import SwiftUI

struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var currentPage: Int = 0
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to JestMind",
            description: "Guess the hidden word in 6 attempts!\nEach letter gets a color clue.",
            icon: "🎯",
            gradientColors: [Color("accentYellow"), Color("primaryRed")]
        ),
        OnboardingPage(
            title: "How to Play",
            description: "🟢 Green - Letter is correct\n🟡 Yellow - Letter exists but wrong position\n🔴 Red - Letter is not in the word",
            icon: "🎮",
            gradientColors: [Color("primaryRed"), Color("accentYellow")]
        ),
        OnboardingPage(
            title: "Game Modes",
            description: "Classic - No time limit\nTimed - 1 minute challenge\nMosaic - Word changes every 2 attempts",
            icon: "⚡",
            gradientColors: [Color("accentYellow"), Color("primaryRed")]
        )
    ]
    
    var body: some View {
        ZStack {
            ZStack {
                Color(red: 0.15, green: 0.15, blue: 0.18)
                    .ignoresSafeArea(.all)
                
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color("primaryRed").opacity(0.15),
                        Color.clear
                    ]),
                    center: UnitPoint(x: 0.15, y: 0.2),
                    startRadius: 50,
                    endRadius: 300
                )
                .ignoresSafeArea(.all)
                
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color("primaryRed").opacity(0.12),
                        Color.clear
                    ]),
                    center: UnitPoint(x: 0.85, y: 0.15),
                    startRadius: 40,
                    endRadius: 280
                )
                .ignoresSafeArea(.all)
                
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color("primaryRed").opacity(0.1),
                        Color.clear
                    ]),
                    center: UnitPoint(x: 0.2, y: 0.8),
                    startRadius: 60,
                    endRadius: 320
                )
                .ignoresSafeArea(.all)
                
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color("primaryRed").opacity(0.13),
                        Color.clear
                    ]),
                    center: UnitPoint(x: 0.9, y: 0.85),
                    startRadius: 45,
                    endRadius: 290
                )
                .ignoresSafeArea(.all)
                
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color("primaryRed").opacity(0.08),
                        Color.clear
                    ]),
                    center: UnitPoint(x: 0.5, y: 0.5),
                    startRadius: 100,
                    endRadius: 400
                )
                .ignoresSafeArea(.all)
            }
            
            VStack(spacing: 0) {
                
                Spacer()
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .animation(.easeInOut, value: currentPage)
                
                Spacer()
                
                HStack(spacing: 20) {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                currentPage -= 1
                            }
                        }) {
                            Text("Previous")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.gray.opacity(0.5),
                                            Color.gray.opacity(0.3)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.white.opacity(0.3),
                                                    Color.white.opacity(0.1)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1.5
                                        )
                                )
                                .cornerRadius(16)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                currentPage += 1
                            }
                        } else {
                            withAnimation {
                                isPresented = false
                            }
                        }
                    }) {
                        Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                ZStack {
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color("primaryRed"),
                                            Color("primaryRed").opacity(0.8)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.3),
                                            Color.clear
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                }
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.white.opacity(0.5),
                                                Color.white.opacity(0.1)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            )
                            .cornerRadius(16)
                            .shadow(color: Color("primaryRed").opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .navigationBarHidden(true)
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
    let gradientColors: [Color]
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isAnimated: Bool = false
    
    var body: some View {
        VStack(spacing: 40) {
            Text(page.icon)
                .font(.system(size: 120))
                .scaleEffect(isAnimated ? 1.0 : 0.5)
                .opacity(isAnimated ? 1.0 : 0.0)
                .rotationEffect(.degrees(isAnimated ? 0 : 180))
                .shadow(
                    color: page.gradientColors.first?.opacity(0.6) ?? Color.clear,
                    radius: 20,
                    x: 0,
                    y: 0
                )
            
            Text(page.title)
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: page.gradientColors),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(
                    color: page.gradientColors.first?.opacity(0.5) ?? Color.clear,
                    radius: 15,
                    x: 0,
                    y: 5
                )
                .opacity(isAnimated ? 1.0 : 0.0)
                .offset(y: isAnimated ? 0 : 20)
            
            Text(page.description)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .padding(.horizontal, 40)
                .opacity(isAnimated ? 1.0 : 0.0)
                .offset(y: isAnimated ? 0 : 20)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                isAnimated = true
            }
        }
    }
}

#Preview {
    OnboardingView(isPresented: .constant(true))
}

