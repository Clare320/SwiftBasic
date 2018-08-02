import Cocoa

let ret1 = (0...10).map {
        $0 * $0
    }.filter {
        $0 % 2 == 0
    }
print(ret1)

// 柯里化 Currying -- 把原接收多个参数的函数 转换成 接收单个参数并且返回以剩余参数为函数参数且返回原结果的新函数 的技术

func addNum(num: Int) -> (Int) -> Int {
    return {
        $0 + num
    }
}
let addTwo = addNum(num: 2)
print(addTwo(3))


// 类 和  结构体 的实例方法支持柯里化

class Dog {
    func bark(time: Int) {
        (1...(time+1)).forEach {
            print("\($0)Wang")
        }
    }
}

let dog = Dog()
let barkFunc = dog.bark
barkFunc(2)

let ret2 = (1...9).map { (i) -> String in
    return (1...i).map({ (j) -> String in
        return "\(j)*\(i)=\(i*j) \t"
    }).joined(separator: "")
}.joined(separator: "\r")
print(ret2)





