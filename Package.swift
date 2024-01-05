// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "EnumProductType",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "EnumProductType",
            targets: ["EnumProductType"]
        ),
        .executable(
            name: "EnumProductTypeClient",
            targets: ["EnumProductTypeClient"]
        ),
    ],
    dependencies: [
        // Depend on the Swift 5.9 release of SwiftSyntax
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    targets: [
        .macro(
            name: "EnumProductTypeMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "EnumProductType", dependencies: ["EnumProductTypeMacros"]),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "EnumProductTypeClient", dependencies: ["EnumProductType"]),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "EnumProductTypeTests",
            dependencies: [
                "EnumProductTypeMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
