//  Created by Dalton Claybrook on 1/5/24.

import Foundation
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

enum ProductMacroDiagnostic {
    case onlyEnums
    case associatedValuesUnsupported
}

extension ProductMacroDiagnostic: DiagnosticMessage {
    var message: String {
        switch self {
        case .onlyEnums:
            return "The Product macro may only be used on enums"
        case .associatedValuesUnsupported:
            return "Enums containing associated values are not supported"
        }
    }
    
    var diagnosticID: MessageID {
        MessageID(domain: "EnumProductTypesMacros", id: String(describing: self))
    }
    
    var severity: DiagnosticSeverity {
        switch self {
        case .onlyEnums, .associatedValuesUnsupported:
            return .error
        }
    }
}

extension MacroExpansionContext {
    func diagnose(node: SyntaxProtocol, message: ProductMacroDiagnostic) {
        diagnose(Diagnostic(node: node, message: message))
    }
}
