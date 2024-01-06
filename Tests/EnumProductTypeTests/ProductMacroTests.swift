import EnumProductTypeMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

let testMacros: [String: Macro.Type] = [
    "Product": ProductMacro.self
]

final class ProductMacroTests: XCTestCase {
    func testMacroWithCaseElementList() throws {
        assertMacroExpansion(
            """
            @Product
            enum Name {
                case first, middle, last
            }
            """,
            expandedSource: """
            enum Name {
                case first, middle, last

                struct Product<T> {
                    var first: T
                    var middle: T
                    var last: T
                }
            }
            """,
            macros: testMacros
        )
    }

    func testMacroWithIndividualCases() throws {
        assertMacroExpansion(
            """
            @Product
            enum Name {
                case first
                case middle
                case last
            }
            """,
            expandedSource: """
            enum Name {
                case first
                case middle
                case last

                struct Product<T> {
                    var first: T
                    var middle: T
                    var last: T
                }
            }
            """,
            macros: testMacros
        )
    }

    func test_ifEnumCaseContainsAssociatedTypes_expansionFails() throws {
        assertMacroExpansion(
            """
            @Product
            enum Name {
                case first
                case middle(String)
                case last
            }
            """,
            expandedSource: """
            enum Name {
                case first
                case middle(String)
                case last
            }
            """,
            diagnostics: [
                .init(message: "Enums containing associated values are not supported", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }

    func test_ifAttachedTypeIsNotAnEnum_expansionFails() throws {
        assertMacroExpansion(
            """
            @Product
            struct MyStruct {
                let foo: Int
            }
            """,
            expandedSource: """
            struct MyStruct {
                let foo: Int
            }
            """,
            diagnostics: [
                .init(message: "This macro can only be used with enums", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }

    func test_ifEnumHasNoCases_warningIsGenerated() throws {
        assertMacroExpansion(
            """
            @Product
            enum Name {
            }
            """,
            expandedSource: """
            enum Name {
            }
            """,
            diagnostics: [
                .init(message: "Product struct will not be generated for a caseless enum", line: 1, column: 1, severity: .warning)
            ],
            macros: testMacros
        )
    }

    func test_ifEnumHasGenericTypes_expansionFails() throws {
        assertMacroExpansion(
            """
            @Product
            enum Name<T: Equatable> {
                case first
                case middle
                case last
            }
            """,
            expandedSource: """
            enum Name<T: Equatable> {
                case first
                case middle
                case last
            }
            """,
            diagnostics: [
                .init(message: "Enums with generic types are not supported", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
}
