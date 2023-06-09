//
//  SFolder.swift
//  AlpineCore
//
//  Created by Jenya Lebid on 4/17/23.
//

//import CoreData
//
//public extension SFolder {
//    
//    static func findOrCreate(for path: FSPath, in context: NSManagedObjectContext = StorageDB.main) -> SFolder {
//        let predicate = NSPredicate(format: "path = %@", path.rawValue)
//        if let folder = SFolder.findObject(by: predicate, in: context) {
//            _ = FS.findOrCreateDirectoryPath(for: path)
//            return folder
//        }
//        
//        return create(for: path, in: context)
//    }
//    
//    
//    static func create(for path: FSPath, in context: NSManagedObjectContext = StorageDB.main) -> SFolder {
//        context.performAndWait {
//            FS.recreateDirectory(at: path, isDirectory: true)
//            let new = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: SFolder.entityName, in: context)!, insertInto: context) as! SFolder
//            new.guid = UUID()
//            new.path = path.rawValue
//            
//            new.save()
//            
//            return new
//        }
//    }
//}
//
//public extension SItem {
//    
//    var fsPath: FSPath {
//        FSPath(rawValue: self.path!)
//    }
//    
//    func fsPath(appending item: String) -> FSPath {
//        self.fsPath.appending(item: item)
//    }
//}
