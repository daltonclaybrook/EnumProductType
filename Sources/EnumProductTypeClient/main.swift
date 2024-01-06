import EnumProductType

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")

@Product
enum Name {
    case first
    case middle
    case last
}

let allNames = Name.Product(first: "John", middle: "Fitzgerald", last: "Kennedy")
