
import SwiftUI

struct ResultView: View {
    @ObservedObject var gameModel: GameModel
    @Binding var isPresented: Bool
    @State private var showContent: Bool = false
    
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
            
            VStack(spacing: 40) {
                Spacer()
                
                Text(gameModel.hasWon ? "🎉" : "💀")
                    .font(.system(size: 140))
                    .opacity(showContent ? 1.0 : 0.0)
                    .scaleEffect(showContent ? 1.0 : 0.5)
                    .shadow(
                        color: gameModel.hasWon ? Color("accentYellow").opacity(0.6) : Color("primaryRed").opacity(0.6),
                        radius: 20,
                        x: 0,
                        y: 0
                    )
                    .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.2), value: showContent)
                
                Text(gameModel.hasWon ? "Won!" : "Lost!")
                    .font(.system(size: 52, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: gameModel.hasWon ?
                                [Color("accentYellow"), Color("accentYellow").opacity(0.8)] :
                                [Color("primaryRed"), Color("primaryRed").opacity(0.8)]
                            ),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(
                        color: gameModel.hasWon ? Color("accentYellow").opacity(0.5) : Color("primaryRed").opacity(0.5),
                        radius: 15,
                        x: 0,
                        y: 5
                    )
                    .opacity(showContent ? 1.0 : 0.0)
                    .animation(.easeIn(duration: 0.5).delay(0.4), value: showContent)
                
                if !gameModel.hasWon {
                    Text("Target word: \(gameModel.targetWord)")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
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
                        )
                        .opacity(showContent ? 1.0 : 0.0)
                        .animation(.easeIn(duration: 0.5).delay(0.6), value: showContent)
                }
                
                Spacer()
                
                Button(action: {
                    isPresented = false
                }) {
                    Text("Home")
                        .padding(.horizontal, 48)
                }
                .buttonStyle(GameButtonStyle())
                .opacity(showContent ? 1.0 : 0.0)
                .animation(.easeIn(duration: 0.5).delay(0.8), value: showContent)
                
                Spacer()
                    .frame(height: 60)
            }
            .padding(.horizontal, 32)
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation {
                showContent = true
            }
        }
    }
}

#Preview {
    ResultView(gameModel: GameModel(), isPresented: .constant(true))
}

