//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

enum SomeEnumeration {
    
}

enum CompassPoint {
    case north
    case south
    case east
    case west
}


var directionToHead = CompassPoint.east
directionToHead = .south

switch directionToHead {
case .north:
    print("Lots of planets have a north")
case .south:
    print("Watch out for penguins")
case .east:
    print("Where the sun rises")
case .west:
    print("Where the skies are blue")
}

// enum类型迭代在Swift4.2后可用
enum Beverage: CaseIterable {
    case coffe, tea, juice
}
let numberOfChoices = Beverage.allCases.count
print("\(numberOfChoices) beverage available")

for beverage in Beverage.allCases {
    print(beverage)
}

enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}
var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode = .qrCode("HelloSky")

switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let value):
    print("QR code: \(value)")
}

/// 这里Raw Values原始值可以是 String characters 任一整型或浮点型
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

/// 原始值如果为整型的话 自动从第一个case原始值递增（默认第一个case原始值为0） 为String类型，则为分支名字
enum Planet: Int, CaseIterable {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}

for item in Planet.allCases {
    print("\(item)'s raw value is \(item.rawValue)")
}

let possiblePlanet = Planet(rawValue: 5) /// jupiter --> 通过rawValue初始化返回的值是optional type

/// indirect key word 可以放在enum之前来标明整个enum中所有case都可递归
enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}

let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) + evaluate(right)
    }
}

// 衣服
// 在enum中定义方法, 这样定义的方法针对每一个case可用
enum Wearable {
    enum Weight: Int {
        case Light = 1
    }
    enum Armor: Int {
        case Light = 2
    }
    case Helmet(weight: Weight, armor: Armor)
    func attributes() {
        switch self {
        case .Helmet(let w, let a):
            print("wearable--->weight: \(w.rawValue * 2), armor: \(a.rawValue * 4)")
        }
    }
}
Wearable.Helmet(weight: .Light, armor: .Light).attributes()

// enum中不能定义存储属性，只能定义计算属性
enum Device {
    case iPad, iPhone, AppleWatch
    
    var year: Int {
        switch self {
        case .iPad:
            return 2007
        case .iPhone:
            return 2010
        case .AppleWatch:
            return 2015
        }
    }
    
    static func fromSlang(term: String) -> Device? {
        if term == "iWatch" {
            return .AppleWatch
        }
        return nil
    }
}

enum TriStateSwitch {
    case Off, Low, High
    mutating func next() {
        switch self {
        case .Off:
            self = .Low
        case .Low:
            self = .High
        case .High:
            self = .Off
        }
    }
}

enum Trade: CustomStringConvertible {
    case Buy, Sell
    var description: String {
        switch self {
        case .Buy: return "We're buying something"
        case .Sell: return "We're selling something"
        }
    }
}
let action = Trade.Buy
print("this action is \(action)")

protocol AccountCompatible {
    var remainingFunds: Int {get}
    mutating func addFunds(amount: Int) throws
    mutating func removeFunds(amount: Int) throws
}

enum Account {
    case Empty
    case Funds(remaining: Int)
    
    enum AccountError: Error {
        case Overdraft(amount: Int)
    }
}

extension Account: AccountCompatible {
    var remainingFunds: Int {
        switch self {
        case .Empty:
            return 0
        case .Funds(let remaining):
            return remaining
        }
    }
    
    mutating func addFunds(amount: Int) throws {
        var newAmount = amount
        if case let .Funds(remaining) = self {
            newAmount += remaining
        }
        if newAmount < 0 {
            throw AccountError.Overdraft(amount: -newAmount)
        } else if newAmount == 0{
            self = .Empty
        } else {
            self = .Funds(remaining: newAmount)
        }
    }
    
    mutating func removeFunds(amount: Int) throws {
        try self.addFunds(amount: amount * -1)
    }
}
var account = Account.Funds(remaining: 20) {
    willSet {
        print("账户将发生变化 \(newValue)")
    }
    didSet {
        print("已经发生变化 \(oldValue)")
    }
}
print(account)
print("add: \(try? account.addFunds(amount: 10))")

account = .Empty

enum Either<T1, T2> {
    case Left(T1)
    case Right(T2)
}

/// reduce两种用法
let array13 = ["hello", "world", "sometimes", "too young", "too sample", "sometimes native"]
let array14 = array13.reduce("LJ") { (result, value) -> String in
    return result.appending(value)
}
print(array14)

let letters = "abracadabra"
let letterCount = letters.reduce(into: [:]) { counts, letter in
//    print("counts:\(counts), letter:\(letter)")
    return counts[letter, default: 0] += 1
}
print("letterCount---->\(letterCount)")
     // letterCount == ["a": 5, "b": 2, "r": 2, "c": 1, "d": 1]

let dict1 = ["1": "A",
             "2": "B",
             "3": "C"
]
print(dict1["4", default: "E"])


/// 嵌套类型

class Inner {
    var value = 42
}

struct Outer {
    var value = 42
    var inner = Inner()
}

class Car {
    var name: String?
}

var outer = Outer()
var outer2 = outer

outer.inner.value = 43

print("outer inner value:\(outer.inner.value),outer2 inner value:\(outer2.inner.value)")

