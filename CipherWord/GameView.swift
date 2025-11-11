
import SwiftUI

struct GameView: View {
    @StateObject private var gameModel: GameModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showResult = false
    @State private var inputText: String = ""
    @State private var previousInputLength: Int = 0
    
    let initialMode: GameMode
    
    init(gameMode: GameMode) {
        self.initialMode = gameMode
        _gameModel = StateObject(wrappedValue: GameModel())
    }
    
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
                    .frame(height: 40)
                
                VStack(spacing: 10) {
                    Text(gameModel.gameMode.rawValue)
                        .font(.system(size: 24, weight: .bold))
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
                        .shadow(color: Color("accentYellow").opacity(0.5), radius: 8, x: 0, y: 4)
                    
                    if gameModel.gameMode == .timed {
                        Text("Time: \(gameModel.timeRemaining) sec")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("primaryRed").opacity(0.3))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        Color("primaryRed").opacity(0.6),
                                                        Color("primaryRed").opacity(0.3)
                                                    ]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1.5
                                            )
                                    )
                            )
                    } else if gameModel.gameMode == .mosaic {
                        Text("Attempt \(gameModel.currentRow + 1)/6")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1.5)
                                    )
                            )
                    }
                }
                .padding(.bottom, 24)
                
                VStack(spacing: 12) {
                    ForEach(0..<6) { row in
                        HStack(spacing: 12) {
                            ForEach(0..<5) { col in
                                GameCellView(cell: gameModel.grid[row][col])
                            }
                        }
                    }
                }
                .padding(24)
                
                Spacer()
                
                TextField("", text: $inputText)
                    .keyboardType(.default)
                    .autocapitalization(.allCharacters)
                    .autocorrectionDisabled()
                    .frame(width: 0, height: 0)
                    .opacity(0)
                    .onChange(of: inputText) { newValue in
                        handleTextInput(newValue)
                    }
                
                EnglishKeyboardView(gameModel: gameModel)
                    .padding(.bottom, 24)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            gameModel.startNewGame(mode: initialMode)
        }
        .onChange(of: gameModel.isGameOver) { _ in
            if gameModel.isGameOver {
                showResult = true
            }
        }
        .sheet(isPresented: $showResult) {
            ResultView(gameModel: gameModel, isPresented: $showResult)
        }
        .onChange(of: showResult) { newValue in
            if !newValue && gameModel.isGameOver {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    private func handleTextInput(_ text: String) {
        guard !gameModel.isGameOver else { return }
        
        let englishLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        if text.count < previousInputLength {
            gameModel.deleteLetter()
            previousInputLength = text.count
            return
        }
        
        if text.contains("\n") {
            gameModel.submitWord()
            inputText = ""
            previousInputLength = 0
            return
        }
        
        let newCharacters = text.uppercased().filter { englishLetters.contains($0) }
        for character in newCharacters {
            if gameModel.currentCol < 5 {
                gameModel.addLetter(String(character))
            }
        }
        
        previousInputLength = text.count
        if text.count > 5 {
            inputText = ""
            previousInputLength = 0
        }
    }
}

struct GameCellView: View {
    let cell: GameCell
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(cellBackgroundColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(cellBorderColor, lineWidth: cell.state == .empty ? 2 : 0)
                )
                .shadow(
                    color: cell.state == .empty ? Color.clear : cellBackgroundColor.opacity(0.4),
                    radius: cell.state == .empty ? 0 : 8,
                    x: 0,
                    y: cell.state == .empty ? 0 : 4
                )
            
            Text(cell.letter)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
        }
    }
    
    var cellBackgroundColor: Color {
        switch cell.state {
        case .empty:
            return Color(red: 0.15, green: 0.15, blue: 0.18)
        case .filled:
            return Color.gray.opacity(0.4)
        case .correct:
            return Color(hex: "#48C95B")
        case .wrongPosition:
            return Color("accentYellow")
        case .wrong:
            return Color("primaryRed")
        }
    }
    
    var cellBorderColor: Color {
        switch cell.state {
        case .empty:
            return Color.gray.opacity(0.6)
        default:
            return Color.clear
        }
    }
}

struct EnglishKeyboardView: View {
    @ObservedObject var gameModel: GameModel
    
    let firstRow = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
    let secondRow = ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
    let thirdRow = ["Z", "X", "C", "V", "B", "N", "M"]
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width - 20
            let keySpacing: CGFloat = 2.5
            let firstRowWidth = calculateRowWidth(count: firstRow.count, spacing: keySpacing, availableWidth: availableWidth)
            let secondRowWidth = calculateRowWidth(count: secondRow.count, spacing: keySpacing, availableWidth: availableWidth)
            
            let totalKeysInThirdRow = thirdRow.count + 2
            let totalSpacingThirdRow = keySpacing * CGFloat(totalKeysInThirdRow - 1)
            let availableForKeys = availableWidth - totalSpacingThirdRow
            
            let actionButtonWidth = max(42, availableForKeys * 0.14)
            let lettersTotalWidth = availableForKeys - (actionButtonWidth * 2)
            let thirdRowWidth = max(24, lettersTotalWidth / CGFloat(thirdRow.count))
            
            VStack(spacing: 8) {
                HStack(spacing: keySpacing) {
                    ForEach(firstRow, id: \.self) { letter in
                        KeyboardButton(
                            letter: letter,
                            letterState: getKeyboardColor(for: letter),
                            isDisabled: isLetterDisabled(for: letter),
                            keyWidth: firstRowWidth
                        ) {
                            gameModel.addLetter(letter)
                        }
                    }
                }
                
                HStack(spacing: keySpacing) {
                    ForEach(secondRow, id: \.self) { letter in
                        KeyboardButton(
                            letter: letter,
                            letterState: getKeyboardColor(for: letter),
                            isDisabled: isLetterDisabled(for: letter),
                            keyWidth: secondRowWidth
                        ) {
                            gameModel.addLetter(letter)
                        }
                    }
                }
                
                HStack(spacing: keySpacing) {
                    KeyboardButton(
                        letter: "⌫",
                        isSpecial: true,
                        isAction: true,
                        keyWidth: actionButtonWidth
                    ) {
                        gameModel.deleteLetter()
                    }
                    
                    ForEach(thirdRow, id: \.self) { letter in
                        KeyboardButton(
                            letter: letter,
                            letterState: getKeyboardColor(for: letter),
                            isDisabled: isLetterDisabled(for: letter),
                            keyWidth: thirdRowWidth
                        ) {
                            gameModel.addLetter(letter)
                        }
                    }
                    
                    KeyboardButton(
                        letter: "Enter",
                        isSpecial: true,
                        isAction: true,
                        keyWidth: actionButtonWidth
                    ) {
                        gameModel.submitWord()
                    }
                }
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity)
        }
        .frame(height: 150)
    }
    
    private func calculateRowWidth(count: Int, spacing: CGFloat, availableWidth: CGFloat) -> CGFloat {
        let totalSpacing = spacing * CGFloat(count - 1)
        let availableForKeys = availableWidth - totalSpacing
        return max(24, availableForKeys / CGFloat(count))
    }
    
    private func getKeyboardColor(for letter: String) -> CellState {
        var bestState: CellState = .empty
        
        let maxRow = gameModel.currentCol == 5 ? gameModel.currentRow + 1 : gameModel.currentRow
        
        for row in 0..<maxRow {
            for col in 0..<5 {
                let usedLetter = gameModel.grid[row][col].letter
                if usedLetter == letter {
                    let cellState = gameModel.grid[row][col].state
                    
                    switch cellState {
                    case .correct:
                        return .correct
                    case .wrongPosition:
                        bestState = .wrongPosition
                    case .wrong:
                        if bestState == .empty {
                            bestState = .wrong
                        }
                    default:
                        break
                    }
                }
            }
        }
        
        return bestState
    }
    
    private func isLetterDisabled(for letter: String) -> Bool {
        let color = getKeyboardColor(for: letter)
        return color == .wrong
    }
}

struct KeyboardButton: View {
    let letter: String
    var isSpecial: Bool = false
    var isAction: Bool = false
    var letterState: CellState = .empty
    var isDisabled: Bool = false
    var keyWidth: CGFloat? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(letter)
                .font(.system(size: isAction ? 11 : (isSpecial ? 15 : 14), weight: .bold))
                .foregroundColor(.white)
                .frame(width: keyWidth, height: 44)
                .background(buttonBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(buttonBorderColor, lineWidth: isDisabled ? 1 : 1.5)
                )
                .cornerRadius(8)
                .shadow(
                    color: buttonShadowColor,
                    radius: isDisabled ? 0 : 4,
                    x: 0,
                    y: isDisabled ? 0 : 2
                )
                .minimumScaleFactor(0.8)
                .lineLimit(1)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
    }
    
    var buttonBackground: some View {
        Group {
            if isAction {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("primaryRed"),
                        Color("primaryRed").opacity(0.8)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                switch letterState {
                case .correct:
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#48C95B"),
                            Color(hex: "#48C95B").opacity(0.8)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                case .wrongPosition:
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color("accentYellow"),
                            Color("accentYellow").opacity(0.8)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                case .wrong:
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color("primaryRed"),
                            Color("primaryRed").opacity(0.8)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                default:
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.gray.opacity(0.4),
                            Color.gray.opacity(0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
        }
    }
    
    var buttonBorderColor: Color {
        if isDisabled {
            return Color.gray.opacity(0.3)
        }
        
        if isAction {
            return Color.white.opacity(0.3)
        }
        
        switch letterState {
        case .correct:
            return Color.white.opacity(0.4)
        case .wrongPosition:
            return Color.white.opacity(0.4)
        case .wrong:
            return Color.white.opacity(0.2)
        default:
            return Color.white.opacity(0.2)
        }
    }
    
    var buttonShadowColor: Color {
        if isDisabled {
            return Color.clear
        }
        
        if isAction {
            return Color("primaryRed").opacity(0.4)
        }
        
        switch letterState {
        case .correct:
            return Color(hex: "#48C95B").opacity(0.4)
        case .wrongPosition:
            return Color("accentYellow").opacity(0.4)
        case .wrong:
            return Color("primaryRed").opacity(0.3)
        default:
            return Color.clear
        }
    }
}

#Preview {
    GameView(gameMode: .classic)
}

