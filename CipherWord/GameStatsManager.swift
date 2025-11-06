
import Foundation
import SwiftUI

class GameStatsManager: ObservableObject {
    @Published var nickname: String {
        didSet {
            saveToUserDefaults()
        }
    }
    
    @Published var totalGames: Int {
        didSet {
            saveToUserDefaults()
        }
    }
    
    @Published var wins: Int {
        didSet {
            saveToUserDefaults()
        }
    }
    
    @Published var losses: Int {
        didSet {
            saveToUserDefaults()
        }
    }
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let nickname = "nickname"
        static let totalGames = "gamesPlayed"
        static let wins = "wins"
        static let losses = "losses"
    }
    
    init() {
        self.nickname = defaults.string(forKey: Keys.nickname) ?? ""
        self.totalGames = defaults.integer(forKey: Keys.totalGames)
        self.wins = defaults.integer(forKey: Keys.wins)
        self.losses = defaults.integer(forKey: Keys.losses)
    }
    
    func recordWin() {
        totalGames += 1
        wins += 1
    }
    
    func recordLoss() {
        totalGames += 1
        losses += 1
    }
    
    func resetStats() {
        totalGames = 0
        wins = 0
        losses = 0
        nickname = ""
    }
    
    var winPercentage: Double {
        guard totalGames > 0 else { return 0.0 }
        return Double(wins) / Double(totalGames) * 100.0
    }
    
    private func saveToUserDefaults() {
        defaults.set(nickname, forKey: Keys.nickname)
        defaults.set(totalGames, forKey: Keys.totalGames)
        defaults.set(wins, forKey: Keys.wins)
        defaults.set(losses, forKey: Keys.losses)
    }
}

