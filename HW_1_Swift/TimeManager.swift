import Foundation

class TimeManager {
    private var timer: Timer?
    var onTick: (() -> Void)?
    
    func start() {
        guard timer == nil else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.onTick?()
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
