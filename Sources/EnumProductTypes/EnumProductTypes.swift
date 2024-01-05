// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces both a value and a string containing the
/// source code that generated the value. For example,
///
///     #stringify(x + y)
///
/// produces a tuple `(x + y, "x + y")`.
@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "EnumProductTypesMacros", type: "StringifyMacro")

/// A macro that attaches to an enum type and adds a member struct called `Product`.
///
/// This generated struct contains properties for each of the enum's cases. For example,
///
///     @Product
///     enum Name {
///         case first, middle, last
///     }
///
/// produces a new member type:
///
///     enum Name {
///         ...
///         struct Product<T> {
///             var first: T
///             var middle: T
///             var last: T
///         }
///     }
///
/// The generated `Product` struct also exposes a handful of helpful convenience methods.
@attached(member, names: named(Product))
public macro Product() = #externalMacro(module: "EnumProductTypesMacros", type: "ProductMacro")
