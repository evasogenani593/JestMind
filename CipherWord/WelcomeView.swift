
import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        NavigationView {
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
                        .frame(height: 80)
                    
                    Text("JestMind")
                        .font(.system(size: 52, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white,
                                    Color("accentYellow")
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: Color("accentYellow").opacity(0.5), radius: 10, x: 0, y: 5)
                        .padding(.bottom, 60)
                    
                    Spacer()
                    
                    VStack(spacing: 24) {
                        NavigationLink(destination: GameView(gameMode: .classic)) {
                            GameModeButton(title: "Classic Mode", color: Color("primaryRed"))
                        }
                        
                        ModeSelectorView()
                            .padding(.horizontal, 32)
                        
                        NavigationLink(destination: GameView(gameMode: .timed)) {
                            GameModeButton(title: "Timed (1 minute)", color: Color("accentYellow"), isActive: true)
                        }
                        
                        ModeSelectorView()
                            .padding(.horizontal, 32)
                        
                        NavigationLink(destination: GameView(gameMode: .mosaic)) {
                            GameModeButton(title: "Mosaic", color: Color("primaryRed"))
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                    
                    HStack(spacing: 40) {
                        NavigationLink(destination: StatsView()) {
                            VStack(spacing: 8) {
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color("accentYellow"),
                                                Color("primaryRed")
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: Color("accentYellow").opacity(0.5), radius: 5)
                                
                                Text("Stats")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        
                        NavigationLink(destination: ProfileView()) {
                            VStack(spacing: 8) {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color("accentYellow"),
                                                Color("primaryRed")
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: Color("accentYellow").opacity(0.5), radius: 5)
                                
                                Text("Profile")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ModeSelectorView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "chevron.up")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.white.opacity(0.5))
            
            Text("SELECT MODE")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white.opacity(0.8))
                .tracking(2)
            
            Image(systemName: "chevron.down")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.white.opacity(0.5))
        }
    }
}

struct GameModeButton: View {
    let title: String
    let color: Color
    var isActive: Bool = false
    
    var body: some View {
        Text(title)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: isActive ?
                            [Color("accentYellow"), Color("accentYellow").opacity(0.8)] :
                            [Color("primaryRed"), Color("primaryRed").opacity(0.8)]
                        ),
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
            .shadow(color: isActive ? Color("accentYellow").opacity(0.5) : Color("primaryRed").opacity(0.5), radius: 12, x: 0, y: 6)
    }
}

#Preview {
    WelcomeView()
}

