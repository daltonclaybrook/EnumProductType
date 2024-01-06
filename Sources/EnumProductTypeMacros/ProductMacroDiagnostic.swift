//  Created by Dalton Claybrook on 1/5/24.

import Foundation
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

enum ProductMacroDiagnostic {
    case onlyEnums
    case noAssociatedValues
    case noCaselessEnums
    case noGenericTypes
}

extension ProductMacroDiagnostic: DiagnosticMessage {
    var message: String {
        switch self {
        case .onlyEnums:
            return "This macro can only be used with enums"
        case .noAssociatedValues:
            return "Enums containing associated values are not supported"
        case .noCaselessEnums:
            return "Product struct will not be generated for a caseless enum"
        case .noGenericTypes:
            return "Enums with generic types are not supported"
        }
    }
    
    var diagnosticID: MessageID {
        MessageID(domain: "EnumProductTypeMacros", id: String(describing: self))
    }
    
    var severity: DiagnosticSeverity {
        switch self {
        case .onlyEnums, .noAssociatedValues, .noGenericTypes:
            return .error
        case .noCaselessEnums:
            return .warning
        }
    }
}

extension MacroExpansionContext {
    func diagnose(node: SyntaxProtocol, message: ProductMacroDiagnostic) {
        diagnose(Diagnostic(node: node, message: message))
    }
}
