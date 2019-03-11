//
//  ToDo.swift
//  To Do List
//
//  Created by Dmitry Novosyolov on 11/03/2019.
//  Copyright © 2019 Dmitry Novosyolov. All rights reserved.
//
import Foundation

struct ToDo
{
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    var keys: [String]
    {
        return Mirror(reflecting: self).children.compactMap { $0.label }
    }
    var values: [Any]
    {
        return Mirror(reflecting: self).children.compactMap { $0.value }
    }
    
    static func load() -> [ToDo]?
    {
       return loadSampleData()
    }
    
    static func loadSampleData() -> [ToDo]
    {
        return [
            ToDo(title: "Купить хлеб", isComplete: false, dueDate: Date(), notes: nil),
            ToDo(title: "Поздравить с 8 Марта", isComplete: false, dueDate: Date(), notes: nil),
            ToDo(title: "Оплатить Apple аккаунт", isComplete: true, dueDate: Date(), notes: nil),
        ]
    }
}
