import EnumProductTypesMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

let testMacros: [String: Macro.Type] = [
    "stringify": StringifyMacro.self,
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
            }
            """,
            macros: testMacros
        )
    }

    func testInspect() throws {
        assertMacroExpansion(
            """
            @Product
            struct Product<T> {
                var first: T
                var middle: T
                var last: T
            }
            """,
            expandedSource: """
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

    func test_ifEnumCaseContainsAssociatedTypes_diagnosticIsEmitted() throws {
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
                case middle
                case last
            }
            """,
            diagnostics: [
                .init(message: "Foo", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
}
