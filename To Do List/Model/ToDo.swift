//
//  ToDo.swift
//  To Do List
//
//  Created by Dmitry Novosyolov on 11/03/2019.
//  Copyright © 2019 Dmitry Novosyolov. All rights reserved.
//
import UIKit

@objcMembers class ToDo: NSObject, Codable
{
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    init(title: String = String(),
         isComplete: Bool = Bool(),
         dueDate: Date = Date(),
         notes: String? = nil)
    {
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
    }
    
    var encoded: Data?
    {
        let encoder = PropertyListEncoder()
        let data = try? encoder.encode(self)
        
        return data
    }
    
    convenience init?(data: Data?)
    {
        guard let data = data else { return nil }
        let decoder = PropertyListDecoder()
        guard let ToDo = try? decoder.decode(ToDo.self, from: data) else { return nil }
        
        self.init(title: ToDo.title, isComplete: ToDo.isComplete, dueDate: ToDo.dueDate, notes: ToDo.notes)
    }
    
    var keys: [String]
    {
        return Mirror(reflecting: self).children.compactMap { $0.label }
    }
    
    var values: [Any?]
    {
        return Mirror(reflecting: self).children.map { $0.value }
    }
    
    static func loadSampleData() -> [ToDo]
    {
        return [
            ToDo(title: "Купить хлеб", isComplete: false, dueDate: Date(), notes: "Только в 'Тив Там'е"),
            ToDo(title: "Поздравить с 8 Марта", isComplete: false, dueDate: Date(), notes: nil),
            ToDo(title: "Оплатить Apple аккаунт", isComplete: true, dueDate: Date(), notes: nil),
        ]
    }
}
