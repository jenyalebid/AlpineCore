//
//  AppError.swift
//  AlpineCore
//
//  Created by mkv on 1/19/24.
//

import Foundation
import SwiftData

@Model
public class AppError: Hashable {
    
    var guid = UUID()
    var date = Date()
    var file: String?
    var function: String?
    var line: Int?
    var message: String?
    var additionalInfo: String?
    var typeName: String?
    
    var user: CoreUser?
    
    var app: CoreApp?
    
    public init(error: Error, additionalText: String? = nil) {
        if let err = error as? AlpineError {
            self.typeName = err.getType()
            self.file = err.file
            self.function = err.function
            self.line = err.line
            self.message = err.message
        } else {
            self.message = error.log()
        }
        self.additionalInfo = additionalText
    }
    
    public static func add(error: Error, additionalInfo: String? = nil, in context: ModelContext) -> AppError {
        let err = AppError(error: error, additionalText: additionalInfo)
        context.insert(err)
        if let app = Core.shared.app {
            if let contextualApp = context.model(for: app.persistentModelID) as? CoreApp {
                err.app = contextualApp
            }
        }
        try? context.save()
        return err
    }
    
    public var title: String {
        typeName ?? "Unknown error"
    }
    
    public var content: String {
        message ?? "No error description"
    }
}
