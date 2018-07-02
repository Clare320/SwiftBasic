import UIKit

struct SomeStructure {
    
}

class SomeClass {
    
}

struct Resolution {
    var width = 0
    var height = 0
}

class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}

let someResolution = Resolution()
let someVideoMode = VideoMode()

print("This width of someResolution is \(someResolution.width)")
print("This width of someVideoMode is \(someVideoMode.resolution.width)")

someVideoMode.resolution.width = 1280

let vga = Resolution(width: 640, height: 480)

// struct enum 都是值类型

let hd = Resolution(width: 1920, height: 1080)
var cinema = hd
cinema.width = 2048

print("hd: \(hd), cinema: \(cinema)")

let tenEighty = VideoMode()
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty
alsoTenEighty.frameRate = 30.0
print("tenEighty's frameRate is \(tenEighty.frameRate), alsoTenEighty's frameRate is \(alsoTenEighty.frameRate)")

struct FixedLengthRange {
    var firstValue: Int
    let length: Int
}
var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
rangeOfThreeItems.firstValue = 6


