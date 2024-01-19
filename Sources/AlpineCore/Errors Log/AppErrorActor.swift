//
//  AppErrorActor.swift
//  AlpineCore
//
//  Created by mkv on 1/19/24.
//

import Foundation
import SwiftData

actor AppErrorActor: ModelActor {
    
    let modelContainer: ModelContainer
    let modelExecutor: ModelExecutor

    init(modelContainer: ModelContainer/* = ConnectManager.shared.modelContainer*/) {
        self.modelContainer = modelContainer
        let context = ModelContext(modelContainer)
        modelExecutor = DefaultSerialModelExecutor(modelContext: context)
    }
    
    public func makeError(error: Error, additionalInfo: String? = nil, userId: PersistentIdentifier) {
        let err = AppError.add(error: error, additionalInfo: additionalInfo, in: modelContext)
        let user = modelContext.model(for: userId) as? CoreUser
        user?.errors.append(err)
        try? save()
    }
    
    func save() throws {
        try modelContext.save()
    }
}
