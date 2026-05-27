import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var winnerScoreLabel: UILabel!
    
    var winnerName: String!
    var winnerScore: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        winnerLabel.text = "Winner: \(winnerName ?? "PC")"
        winnerScoreLabel.text = "score: \(winnerScore ?? 0)"
    }
    
    @IBAction func backToMenuTapped(_ sender: UIButton) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
