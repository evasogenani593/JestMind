
import SwiftUI

struct InfoView: View {
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
            }
            
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 12) {
                        Text("JestMind")
                            .font(.system(size: 48, weight: .bold))
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
                        
                        Text("How to Play")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.top, 20)
                    
                    InfoSection(
                        title: "General Rules",
                        icon: "gamecontroller.fill",
                        color: Color("primaryRed")
                    ) {
                        VStack(alignment: .leading, spacing: 16) {
                            InfoRow(
                                icon: "1.circle.fill",
                                text: "Guess a 5-letter word in 6 attempts"
                            )
                            InfoRow(
                                icon: "2.circle.fill",
                                text: "Type letters using the keyboard or physical keyboard"
                            )
                            InfoRow(
                                icon: "3.circle.fill",
                                text: "Press Enter or tap the Enter button to submit your guess"
                            )
                            InfoRow(
                                icon: "4.circle.fill",
                                text: "Use the backspace button to delete letters"
                            )
                        }
                    }
                    
                    InfoSection(
                        title: "Color Guide",
                        icon: "paintpalette.fill",
                        color: Color("accentYellow")
                    ) {
                        VStack(alignment: .leading, spacing: 16) {
                            ColorGuideRow(
                                color: Color(hex: "#48C95B"),
                                text: "Green - Letter is correct and in the right position"
                            )
                            ColorGuideRow(
                                color: Color("accentYellow"),
                                text: "Yellow - Letter is in the word but in the wrong position"
                            )
                            ColorGuideRow(
                                color: Color("primaryRed"),
                                text: "Red - Letter is not in the word"
                            )
                        }
                    }
                    
                    VStack(spacing: 24) {
                        Text("Game Modes")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                        
                        GameModeInfoCard(
                            title: "Classic Mode",
                            color: Color("primaryRed"),
                            icon: "clock.fill"
                        ) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("• Take your time to think")
                                Text("• 6 attempts to guess the word")
                                Text("• No time pressure")
                                Text("• Perfect for learning and practice")
                            }
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                        }
                        
                        GameModeInfoCard(
                            title: "Timed Mode",
                            color: Color("accentYellow"),
                            icon: "timer"
                        ) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("• 1 minute time limit")
                                Text("• Race against the clock")
                                Text("• Test your speed and accuracy")
                                Text("• Game ends when time runs out")
                            }
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                        }
                        
                        GameModeInfoCard(
                            title: "Mosaic Mode",
                            color: Color("primaryRed"),
                            icon: "square.grid.3x3.fill"
                        ) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("• The target word changes every 2 attempts")
                                Text("• Adapt quickly to new words")
                                Text("• More challenging and dynamic")
                                Text("• Keep track of multiple words")
                            }
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    InfoSection(
                        title: "Tips & Strategies",
                        icon: "lightbulb.fill",
                        color: Color("accentYellow")
                    ) {
                        VStack(alignment: .leading, spacing: 16) {
                            InfoRow(
                                icon: "star.fill",
                                text: "Start with common vowels (A, E, I, O, U)"
                            )
                            InfoRow(
                                icon: "star.fill",
                                text: "Use your first guess to test multiple letters"
                            )
                            InfoRow(
                                icon: "star.fill",
                                text: "Pay attention to yellow letters - they're in the word!"
                            )
                            InfoRow(
                                icon: "star.fill",
                                text: "The keyboard shows which letters you've already tried"
                            )
                            InfoRow(
                                icon: "star.fill",
                                text: "Disabled keys (grayed out) are not in the word"
                            )
                        }
                    }
                    
                    Spacer()
                        .frame(height: 40)
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32))
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
                    }
                    .padding(.trailing, 24)
                    .padding(.top, 16)
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct InfoSection<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let content: Content
    
    init(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color,
                                color.opacity(0.8)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: color.opacity(0.5), radius: 5)
                
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 24)
            
            content
                .padding(.horizontal, 24)
        }
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(Color("accentYellow"))
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct ColorGuideRow: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            RoundedRectangle(cornerRadius: 6)
                .fill(color)
                .frame(width: 24, height: 24)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
            
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct GameModeInfoCard<Content: View>: View {
    let title: String
    let color: Color
    let icon: String
    let content: Content
    
    init(title: String, color: Color, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.color = color
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            
            content
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            color.opacity(0.2),
                            color.opacity(0.1)
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
                                    color.opacity(0.5),
                                    color.opacity(0.2)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
        )
        .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    InfoView()
}


