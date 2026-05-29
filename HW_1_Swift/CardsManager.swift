import UIKit

struct Card {
    let name: String
    let value: Int
    
    var image: UIImage? {
        return UIImage(named: name)
    }
}

class CardManager {
    private let cardsHearts: [String: Int] = [
        "ace-of-hearts": 11,
        "king-of-hearts": 10,
        "queen-of-hearts": 10,
        "jack-of-hearts": 10,
        "ten-of-hearts": 10,
        "nine-of-hearts": 9,
        "eight-of-hearts": 8,
        "seven-of-hearts": 7,
        "six-of-hearts": 6,
        "five-of-hearts": 5,
        "four-of-hearts": 4,
        "three-of-hearts": 3,
        "two-of-hearts": 2
    ]
    
    private let cardsSpades: [String: Int] = [
        "ace-of-spades": 11,
        "king-of-spades": 10,
        "queen-of-spades": 10,
        "jack-of-spades": 10,
        "ten-of-spades": 10,
        "nine-of-spades": 9,
        "eight-of-spades": 8,
        "seven-of-spades": 7,
        "six-of-spades": 6,
        "five-of-spades": 5,
        "four-of-spades": 4,
        "three-of-spades": 3,
        "two-of-spades": 2
    ]
    
    func getRandomHeartCard() -> Card? {
        guard let randomCard = cardsHearts.randomElement() else { return nil }
        return Card(name: randomCard.key, value: randomCard.value)
    }
    
    func getRandomSpadeCard() -> Card? {
        guard let randomCard = cardsSpades.randomElement() else { return nil }
        return Card(name: randomCard.key, value: randomCard.value)
    }
    
    func compareCards(card1: Card, card2: Card) -> Int {
        if card1.value > card2.value {
            return 1
        } else if card1.value < card2.value {
            return -1
        } else {
            return 0
        }
    }
}
