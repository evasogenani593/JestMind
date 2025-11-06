
import SwiftUI

struct StatsView: View {
    @StateObject private var statsManager = GameStatsManager()
    @Environment(\.presentationMode) var presentationMode
    
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
                    .frame(height: 70)
                
                Text("Statistics")
                    .font(.system(size: 42, weight: .bold))
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
                    .padding(.bottom, 50)
                
                VStack(spacing: 28) {
                    StatRow(title: "Games Played", value: "\(statsManager.totalGames)")
                    StatRow(title: "Wins", value: "\(statsManager.wins)")
                    
                    Divider()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.4),
                                    Color.white.opacity(0.1)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .padding(.horizontal, 40)
                        .padding(.vertical, 8)
                    
                    StatRow(title: "Win Percentage", value: String(format: "%.1f%%", statsManager.winPercentage))
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.2),
                                            Color.white.opacity(0.05)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                )
                .padding(.horizontal, 24)
                
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back")
                        .padding(.horizontal, 48)
                }
                .buttonStyle(GameButtonStyle())
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
            }
        }
        .navigationBarHidden(true)
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color("accentYellow"),
                            Color("accentYellow").opacity(0.8)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: Color("accentYellow").opacity(0.4), radius: 5)
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    StatsView()
}

