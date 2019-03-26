//
//  ToDo.swift
//  To Do List
//
//  Created by Dmitry Novosyolov on 11/03/2019.
//  Copyright © 2019 Dmitry Novosyolov. All rights reserved.
//
import UIKit
import CloudKit

@objcMembers class ToDo: NSObject
{
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    var image: UIImage

    init(title: String = String(),
         isComplete: Bool = Bool(),
         dueDate: Date = Date(),
         notes: String? = nil,
         image: UIImage = UIImage())
    {
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
        self.image = UIImage(named: "imagePlaceholder")!
    }
    
//    func genericFromCloudToDo<T>(fieldType: T) -> T
//    {
//        return fieldType
//    }

    var keys: [String]
    {
        return Mirror(reflecting: self).children.compactMap { $0.label }
    }
    
    var values: [Any?]
    {
        return Mirror(reflecting: self).children.map { $0.value }
    }
}

// MARK: - ... CloudKit
extension ToDo
{
    convenience init?(record: CKRecord) {
        self.init()
        
        for (index, key) in self.keys.enumerated()
        {
            let value = self.values[index]
            let newValue = record.object(forKey: key)
            
            switch value
            {
            case is String:
                guard let newValue = newValue as? String
                    else { return nil }
                self.setValue(newValue, forKey: key)
                
            case is Bool:
                guard let newValue = newValue as? Int
                    else { return nil }
                self.setValue(newValue != 0, forKey: key)
                
            case is Date:
                guard let newValue = newValue as? Date
                    else { return nil }
                self.setValue(newValue, forKey: key)
                
            case is UIImage:
                guard let imageAsset = newValue as? CKAsset
                    else { return nil }
                guard let imageData = try? Data(contentsOf:
                    imageAsset.fileURL!)
                    else { return nil }
                guard let image = UIImage(data: imageData)
                    else { return nil }
                self.setValue(image, forKey: key)
                
            case is String?:
                guard let newValue = newValue as? String
                    else { return nil }
                self.setValue(newValue, forKey: key)
                
            default:
                print(#function, "Unknow field type on line: \(#line)")
            }
        }
    }
    
    static func loadFromCloudKit(completion: @escaping ([ToDo]?) -> Void)
    {
        let cloudContainer = CKContainer.default()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "ToDo", predicate: predicate)
        
        publicDatabase.perform(query, inZoneWith: nil) { results, _ in
            guard let results = results else {
                completion(nil)
                return
            }
            
            let todos = results.compactMap { ToDo(record: $0) }
            
            print(#function, "todos.count =", todos.count)
            completion(todos)
        }
    }
}
