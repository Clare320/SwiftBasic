import Cocoa

let ret1 = (0...10).map {
        $0 * $0
    }.filter {
        $0 % 2 == 0
    }
print(ret1)
