/// A macro that attaches to an enum declaration and adds a member struct called `Product`
/// containing properties for each of the enum's cases.
///
/// For example:
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
public macro Product() = #externalMacro(module: "EnumProductTypeMacros", type: "ProductMacro")
