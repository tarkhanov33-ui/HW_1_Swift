import Foundation
class TimeManager{
    private var timer: Timer?
    var onTick: ((String) -> Void)?
    private var secondsCounter = 0
    var secondsUpdate: ((Int) -> Void)?
    func start() {
            guard timer == nil else { return }
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.secondsCounter += 1
                self?.secondsUpdate?(self?.secondsCounter ?? 0)
            }
        }
        
        func pause() {
            timer?.invalidate()
            timer = nil
        }
        
        func reset() {
            pause()
            secondsCounter = 0
            secondsUpdate?(secondsCounter)
        }
    }

