import UIKit

// Class for rawValue needs to conform two protocol
// 1. Equatable
// 2. ExpressibleByStringLiteral
class MyStateObject: Equatable, ExpressibleByStringLiteral {
    // Define a property to save identity data
    var identity: String = ""
    
    // ExpressibleByStringLiteral
    typealias StringLiteralType = String
    
    // Implement == function to conform Equatable
    static func == (lhs: MyStateObject, rhs: MyStateObject) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    // Implement constructor to conform ExpressibleByStringLiteral
    required init(stringLiteral value: String) {
        self.identity = value
    }
    
    // functions you wanna execute or values you wanna cache
    var value: Int {
        return 0
    }
    func doSomething() {
        
    }
}

// Sub classes, use singleton pattern
class FirstStateObject: MyStateObject {
    static let shared = FirstStateObject(stringLiteral: "first")
    override var value: Int {
        return 1
    }
    override func doSomething() {
        print("First state action done")
    }
}
class SecondStateObject: MyStateObject {
    static let shared = SecondStateObject(stringLiteral: "second")
    override var value: Int {
        return 2
    }
    override func doSomething() {
        print("Second state action done")
    }
}
class ThirdStateObject: MyStateObject {
    static let shared = ThirdStateObject(stringLiteral: "third")
    override var value: Int {
        return 3
    }
    override func doSomething() {
        print("Third state action done")
    }
}

// Use MyStateObject as enum's rawValue
// CaseIterable to make enum iterable
enum MyEnum: MyStateObject, CaseIterable {
    case firstState
    case secondState
    case thirdState
}

// Enum needs to conform RawRepresentable
extension MyEnum: RawRepresentable {
    // Implement rawValue getter to conform RawRepresentable
    // Based on cases to return corresponded MyStateObject
    var rawValue: MyStateObject {
        switch self {
        case .firstState:
            return FirstStateObject.shared
        case .secondState:
            return SecondStateObject.shared
        case .thirdState:
            return ThirdStateObject.shared
        }
    }
    
    // Indicated RawValue type to MyStateObject
    typealias RawValue = MyStateObject
    
    // Implement constructor to conform RawRepresentable
    // Based on input rawValue to assign enum case
    init?(rawValue: MyStateObject) {
        switch rawValue {
        case FirstStateObject.shared: self = .firstState
        case SecondStateObject.shared: self = .secondState
        case ThirdStateObject.shared: self = .thirdState
        default:
            return nil
        }
    }
}

// Usage
MyEnum.firstState.rawValue.doSomething()
let sum = MyEnum.firstState.rawValue.value + MyEnum.secondState.rawValue.value + MyEnum.thirdState.rawValue.value
print("Get total value from states: \(sum)")

// For loop
var max = 0
for state in MyEnum.allCases {
    if max < state.rawValue.value {
        max = state.rawValue.value
    }
}
print("Get max value from states: \(max)")
