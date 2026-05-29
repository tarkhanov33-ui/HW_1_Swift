import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var leftNameLabel: UILabel!
    @IBOutlet weak var leftScoreLabel: UILabel!
    @IBOutlet weak var rightNameLabel: UILabel!
    @IBOutlet weak var rightScoreLabel: UILabel!
    
    @IBOutlet weak var leftCardImageView: UIImageView!
    @IBOutlet weak var rightCardImageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var playerName: String!
    var playerSide: PlayerSide!
    
    private var gameManager: GameManager!
    private let cardManager = CardManager()
    private let timeManager = TimeManager()
    private var secondsLeftInRound = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameManager = GameManager(playerName: playerName, playerSide: playerSide)
        setupPlayersUI()
        resetCardsToBack(animated: false)
        startNewGame()
    }
    
    private func setupPlayersUI() {
        leftNameLabel.text = gameManager.leftPlayerName
        rightNameLabel.text = gameManager.rightPlayerName
        leftScoreLabel.text = "0"
        rightScoreLabel.text = "0"
    }
    
    private func resetCardsToBack(animated: Bool) {
        let backImage = UIImage(systemName: "questionmark.square")
        if animated {
            UIView.transition(with: leftCardImageView, duration: 0.3, options: .transitionFlipFromRight, animations: {
                self.leftCardImageView.image = backImage
            }, completion: nil)
            UIView.transition(with: rightCardImageView, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                self.rightCardImageView.image = backImage
            }, completion: nil)
        } else {
            leftCardImageView.image = backImage
            rightCardImageView.image = backImage
        }
    }
    
    private func startNewGame() {
        secondsLeftInRound = 5
        timerLabel.text = "\(secondsLeftInRound)"
        
        timeManager.onTick = { [weak self] in
            self?.timerTicked()
        }
        timeManager.start()
        
        playCurrentRound()
    }
    
    private func timerTicked() {
        secondsLeftInRound -= 1
        
        if secondsLeftInRound == 0 {
            if gameManager.isGameOver {
                endGame()
                return
            }
            secondsLeftInRound = 5
            timerLabel.text = "\(secondsLeftInRound)"
            playCurrentRound()
        } else {
            timerLabel.text = "\(secondsLeftInRound)"
            if secondsLeftInRound == 2 {
                resetCardsToBack(animated: true)
            }
        }
    }
    
    private func playCurrentRound() {
        guard let leftCard = cardManager.getRandomSpadeCard(),
              let rightCard = cardManager.getRandomHeartCard() else {
            return
        }
        
        let result = gameManager.playRound(leftCard: leftCard, rightCard: rightCard)
        
        leftScoreLabel.text = "\(result.leftScore)"
        rightScoreLabel.text = "\(result.rightScore)"
        
        UIView.transition(with: leftCardImageView, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            self.leftCardImageView.image = leftCard.image
        }, completion: nil)
        
        UIView.transition(with: rightCardImageView, duration: 0.3, options: .transitionFlipFromRight, animations: {
            self.rightCardImageView.image = rightCard.image
        }, completion: nil)
    }
    
    private func endGame() {
        timeManager.stop()
        
        let (winnerName, winnerScore) = gameManager.getWinnerAndScore()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultVC = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
            resultVC.winnerName = winnerName
            resultVC.winnerScore = winnerScore
            resultVC.modalPresentationStyle = .fullScreen
            present(resultVC, animated: true)
        }
    }
    
    deinit {
        timeManager.stop()
    }
}
