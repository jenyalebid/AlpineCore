//
//  CDBatchFetcher.swift
//  AlpineCore
//
//  Created by Jenya Lebid on 5/26/23.
//

import CoreData

public class CDBatchFetcher {
    
    private let fetchRequest: NSFetchRequest<NSManagedObject>

    private var currentBatch = 0

    public init(for entityName: String, using predicate: NSPredicate?, with batchSize: Int) {
        fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.fetchBatchSize = batchSize
        fetchRequest.fetchLimit = batchSize
        fetchRequest.returnsObjectsAsFaults = false
    }

    public func fetchObjectBatch(in context: NSManagedObjectContext) throws -> [NSManagedObject]? {
        fetchRequest.fetchOffset = currentBatch * fetchRequest.fetchLimit

        let results = try context.fetch(fetchRequest)
        
        currentBatch += 1
        return results.isEmpty ? nil : results
    }
}
