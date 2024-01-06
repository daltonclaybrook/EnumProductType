import EnumProductType

@Product
enum Name {
    case first
    case middle
    case last
}

let allNames = Name.Product(first: "John", middle: "Fitzgerald", last: "Kennedy")
