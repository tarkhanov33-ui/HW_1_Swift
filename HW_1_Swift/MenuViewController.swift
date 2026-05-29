import UIKit
import CoreLocation

class MenuViewController: UIViewController, LocationManagerDelegate {
    
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var hiLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var westGlobeContainer: UIView!
    @IBOutlet weak var westGlobeImage: UIImageView!
    @IBOutlet weak var westSideLabel: UILabel!
    
    @IBOutlet weak var eastGlobeContainer: UIView!
    @IBOutlet weak var eastGlobeImage: UIImageView!
    @IBOutlet weak var eastSideLabel: UILabel!
    
    private let locationManager = LocationManager()
    private var playerSide: PlayerSide?
    private var playerName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestLocation()
        updateUIState()
    }
    
    private func updateUIState() {
        if let name = playerName {
            hiLabel.text = "Hi \(name)"
            hiLabel.isHidden = false
            nameButton.isHidden = true
        } else {
            hiLabel.isHidden = true
            nameButton.isHidden = false
        }
        
        let hasRequirements = (playerName != nil) && (playerSide != nil)
        startButton.isHidden = !hasRequirements
        startButton.isEnabled = hasRequirements
    }
    
    @IBAction func nameButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Enter Name", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Your Name"
            textField.text = self.playerName
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            if let name = alert.textFields?.first?.text, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self?.playerName = name
                self?.updateUIState()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        guard let name = playerName, let side = playerSide else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let gameVC = storyboard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController {
            gameVC.playerName = name
            gameVC.playerSide = side
            gameVC.modalPresentationStyle = .fullScreen
            present(gameVC, animated: true)
        }
    }
    
    func didUpdateLocation(latitude: Double, longitude: Double) {
        let arielLongitude = 34.817549168324334
        if longitude > arielLongitude {
            playerSide = .right
            eastGlobeContainer.alpha = 1.0
            westGlobeContainer.alpha = 0.3
            eastSideLabel.font = UIFont.boldSystemFont(ofSize: 18)
            westSideLabel.font = UIFont.systemFont(ofSize: 16)
        } else {
            playerSide = .left
            westGlobeContainer.alpha = 1.0
            eastGlobeContainer.alpha = 0.3
            westSideLabel.font = UIFont.boldSystemFont(ofSize: 18)
            eastSideLabel.font = UIFont.systemFont(ofSize: 16)
        }
        updateUIState()
    }
    
    func didFailWithError(_ error: Error) {
        print("Location retrieval failed: \(error.localizedDescription)")
        let alert = UIAlertController(title: "Location Required", message: "Please enable location services or simulate location to play.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
