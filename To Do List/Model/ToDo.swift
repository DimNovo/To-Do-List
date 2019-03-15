//
//  ToDo.swift
//  To Do List
//
//  Created by Dmitry Novosyolov on 11/03/2019.
//  Copyright © 2019 Dmitry Novosyolov. All rights reserved.
//
import Foundation

 @objcMembers class ToDo: NSObject
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
    
    var keys: [String]
    {
        return Mirror(reflecting: self).children.compactMap { $0.label }
    }
    
    var values: [Any?]
    {
        return Mirror(reflecting: self).children.map { $0.value }
    }
    
    static func loadData() -> [ToDo]?
    {
        return loadSampleData()
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


//    var capitalaizedKeys: [String]
//    {
//        let nonCpitalized = Mirror(reflecting: self).children.compactMap { $0.label }
//
//        var words = [String]()
//
//        nonCpitalized.forEach { word in
//            var splitWord = ""
//
//            for character in word {
//                if String(character) == String(character).localizedUppercase {
//                    splitWord += " "
//                }
//                splitWord += "\(character)"
//            }
//            words += [splitWord.localizedCapitalized]
//        }
//        return words
//    }
