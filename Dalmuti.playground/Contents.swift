// The Great Dalmuti
//import UIKit
import Foundation

struct Card: Equatable, Comparable, CustomStringConvertible {
    let level: Int
    var description: String {
        return "\(level)"
    }
    
    static func < (lhs: Card, rhs: Card) -> Bool {
        return lhs.level < rhs.level
    }
    
}

// struct -> class
class Stack {
    var ownCards: [Card]
    var isEmpty: Bool {
        return ownCards.isEmpty
    }
    var gotJocker: Bool = false
    
    init(ownCards: [Card]) {
        self.ownCards = ownCards
        self.sortCard()
    }
    func sortCard () {
        ownCards.sorted(by: { $0.level > $1.level })
    }
    func addCard (newCard: Card) {
        ownCards.append(newCard)
    }
    func delCard (level: Int, count: Int) {
        for _ in 1...count {
            guard let idx = ownCards.firstIndex(where: { $0.level == level }) else { continue }
            ownCards.remove(at: idx)
        }
    }
    func checkCard (level: Int, count: Int) -> Bool {
        if level < count { return false }
        // jocker option
        var cnt: Int = 0
        for card in ownCards {
            if card.level == level {
                cnt += 1
            }
        }
        if cnt < count {
            return false
        } else { return true }
    }
    
}

struct Deck {
    let totalNum: Int = 80
    let numLevel: Int
    var initDeck: [Card] = []
    
    init(_ numLevel: Int = 13) {
        self.numLevel = numLevel
        for i in 1...numLevel-1 {
            initDeck += Array.init(repeating: Card(level:i), count: i)
        }
        initDeck += Array.init(repeating: Card(level:14), count: 2)
    }
    
    func dealOut (numPlayers: Int) -> [Stack] {
        let newDeck = initDeck.shuffled()
        let eachOwn: Int = Int(totalNum/numPlayers) // floor
        var retStack: [Stack] = []
        for i in 1...numPlayers {
            // fucking array slice
            retStack.append(Stack(ownCards: Array(newDeck[(i-1)*eachOwn..<i*eachOwn])))
        }
        return retStack
    }
}

struct Player {
    var number: Int = 0
    var level: Int = 0
    var myStack: Stack
    
    init (number: Int, level: Int, myStack: Stack) {
        self.number = number
        self.level = level
        self.myStack = myStack
    }
    // init everytime??
//    mutating func newGame(newLevel: Int, newStack: Stack) {
//        level = newLevel
//        myStack = newStack
//    }
    func myTurn (level: Int, count: Int) -> (Int, Int) {
        let newLevel: Int
        let newCount: Int
        
        if count > 0 {
            // something for newlevel
            newLevel = level-1
            newCount = count
        }
        else {
            // something for newlevel and count
            newLevel = level-1
            newCount = 1
        }
        if myStack.checkCard(level: newLevel, count: newCount) {
            myStack.delCard(level: newLevel, count: newCount)
            print("[G] Player #\(self.number) paid \(count) Card\(level).")
        }
        return (newLevel, newCount)
    }
    
    func autoTurn (level: Int, count: Int) -> (Int, Int) {
        let newLevel: Int
        let newCount: Int
        
        if count > 0 {
            // something for newlevel
            newLevel = level-1
            newCount = count
        }
        else {
            // something for newlevel and count
            newLevel = level-1
            newCount = 1
        }
        if myStack.checkCard(level: newLevel, count: newCount) {
            myStack.delCard(level: newLevel, count: newCount)
            print("[G] Player #\(self.number) paid \(count) Card\(level).")
        }
        return (newLevel, newCount)
    }
}

struct Game {
    var numPlayers: Int
    var isFirst: Bool = true
    var players: [Player] = []
    var order: [Int] = []
    var newOrder: [Int] = []
    var deck: Deck = Deck()
    
    init (numPlayers: Int) {
        self.numPlayers = numPlayers
        self.newOrder = setOrder()
        newGame()
        self.isFirst = false
    }
    func setOrder() -> [Int] {
        let order = 0..<numPlayers
        let newOrder = order.shuffled()
        return newOrder
    }
    mutating func newGame() {
        let newStack = deck.dealOut(numPlayers: numPlayers)
        self.order = newOrder
        self.newOrder = []
        for i in 0..<numPlayers {
            players.append(Player(number: order[i], level: i, myStack: newStack[i]))
            print("[N] Player #\(players[i].number) : \(i+1)-th class")   // dict level to string
        }
        //players.sort{ $0.level > $1.level }
        print(players)
    }
    func revolution () {
        
    }
    func payTax () {
        
    }
    mutating func letsPlay () {
        var level: Int = 14, count: Int = 0
        while true {
            for i in self.order {
                if newOrder.contains(players[i].number) { continue }
                
                (level, count) = players[i].myTurn(level: level, count: count)
                
                if players[i].myStack.isEmpty {
                    newOrder.append(players[i].number)
                    print("[N] Player #\(players[i].number) is done.")
                    count = 0
                }
            }
            if newOrder.count == numPlayers { break }
        }
        newGame()
    }
}




var game = Game(numPlayers: 4)
while true {
    game.letsPlay()
    break
}
