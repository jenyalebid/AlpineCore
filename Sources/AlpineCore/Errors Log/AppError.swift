//
//  AppError.swift
//  AlpineCore
//
//  Created by mkv on 1/19/24.
//

import Foundation
import SwiftData

@Model
public class AppError {
    
    var guid = UUID()
    var date = Date()
    var file: String?
    var function: String?
    var line: Int?
    var message: String?
    var additionalInfo: String?
    var typeName: String?
    
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
        try? context.save()
        return err
    }
}
