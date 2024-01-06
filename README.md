# EnumProductType

A [Swift Macro](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/) for generating
[product types](https://en.wikipedia.org/wiki/Product_type) for your enums.

## Problem

Enums in Swift are "[Sum types](https://en.wikipedia.org/wiki/Tagged_union)." An instance of an enum can hold only one
of several different cases declared as members of the enum. The dual of sum types are product types. Structs in Swift
are product types because they hold all members simultaneously rather than one member at a time.

But what if you want your enum to behave like a product type in certain circumstances? Consider the following enum:

```swift
enum Season {
    case spring
    case summer
    case autumn
    case winter
}
```

This type exists to enumerate the seasons of the year so that you can indicate a particular season of interest. But
occasionally you may want to associate some data with all seasons at once, for example, colors.

## The Product Macro

Using this package, we can annotate the `Season` enum with the `@Product` macro:

```swift
@Product
enum Season {
    case spring
    case summer
    case autumn
    case winter
}
```

This will generate a new member struct under the `Season` namespace called `Product`:

```swift
@Product
enum Season {
    ...
    struct Product<T> {
        var spring: T
        var summer: T
        var autumn: T
        var winter: T
    }
}
```

This enables you to create an instance of `Season` and specify values for each member case:

```swift
let seasonalColors = Season.Product<Color>(
    spring: .green,
    summer: .yellow,
    autumn: .orange,
    winter: .white
)
```
