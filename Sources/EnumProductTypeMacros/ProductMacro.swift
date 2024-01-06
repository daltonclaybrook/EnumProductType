//  Created by Dalton Claybrook on 1/5/24.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ProductMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let decl = declaration.as(EnumDeclSyntax.self) else {
            context.diagnose(node: declaration, message: .onlyEnums)
            return []
        }

        guard decl.genericParameterClause == nil else {
            context.diagnose(node: decl, message: .noGenericTypes)
            return []
        }

        let caseElements = getCaseElements(from: decl)
        guard enumCaseContainsAssociatedValue(in: caseElements) == false else {
            context.diagnose(node: decl, message: .noAssociatedValues)
            return []
        }

        guard caseElements.isEmpty == false else {
            context.diagnose(node: decl, message: .noCaselessEnums)
            return []
        }

        let members = makeProductMemberList(from: caseElements)
        return [
            makeProductStruct(with: members)
        ]
    }

    // MARK: - Private helpers

    private static func getCaseElements(from decl: EnumDeclSyntax) -> [EnumCaseElementSyntax] {
        decl.memberBlock.members.flatMap { member -> [EnumCaseElementSyntax] in
            guard let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) else { return [] }
            return Array(caseDecl.elements)
        }
    }

    /// Returns true if the provided list of enum case elements contains a case with an associated value
    private static func enumCaseContainsAssociatedValue(in caseElements: [EnumCaseElementSyntax]) -> Bool {
        caseElements.contains { element in
            element.parameterClause != nil
        }
    }

    private static func makeProductMemberList(from caseElements: [EnumCaseElementSyntax]) -> MemberBlockItemListSyntax {
        let members: [MemberBlockItemSyntax] = caseElements.enumerated().map { element in
            let isLast = element.offset == caseElements.count - 1
            return MemberBlockItemSyntax(
                decl: VariableDeclSyntax(bindingSpecifier: .keyword(.var)) {
                    PatternBindingSyntax(
                        leadingTrivia: .space,
                        pattern: IdentifierPatternSyntax(identifier: .identifier(element.element.name.text)),
                        typeAnnotation: TypeAnnotationSyntax(
                            colon: .colonToken(),
                            type: IdentifierTypeSyntax(name: "T")
                        )
                    )
                },
                trailingTrivia: isLast ? nil : .newline
            )
        }
        return MemberBlockItemListSyntax(members)
    }

    private static func makeProductStruct(with memberList: MemberBlockItemListSyntax) -> DeclSyntax {
        """
        struct Product<T> {
            \(memberList)
        }
        """
    }
}

@main
struct EnumProductTypePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ProductMacro.self
    ]
}

enum Foo {
    case bar(String), fizz, buzz
}
