import Foundation

enum PlayerSide {
    case left
    case right
}

class GameManager {
    let maxRounds = 10
    private(set) var currentRound = 0
    private(set) var leftScore = 0
    private(set) var rightScore = 0
    
    let playerName: String
    let playerSide: PlayerSide
    
    init(playerName: String, playerSide: PlayerSide) {
        self.playerName = playerName
        self.playerSide = playerSide
    }
    
    var leftPlayerName: String {
        return playerSide == .left ? playerName : "PC"
    }
    
    var rightPlayerName: String {
        return playerSide == .right ? playerName : "PC"
    }

    func playRound(leftCard: Card, rightCard: Card) -> (winner: String, leftScore: Int, rightScore: Int) {
        currentRound += 1
        
        let comparison = leftCard.value - rightCard.value
        var winner = "Tie"
        
        if comparison > 0 {
            leftScore += 1
            winner = leftPlayerName
        } else if comparison < 0 {
            rightScore += 1
            winner = rightPlayerName
        }
        
        return (winner, leftScore, rightScore)
    }
    
    var isGameOver: Bool {
        return currentRound >= maxRounds
    }
    
    func getWinnerAndScore() -> (name: String, score: Int) {
        if leftScore > rightScore {
            return (leftPlayerName, leftScore)
        } else if rightScore > leftScore {
            return (rightPlayerName, rightScore)
        } else {
            let pcScore = playerSide == .left ? rightScore : leftScore
            return ("PC", pcScore)
        }
    }
}
