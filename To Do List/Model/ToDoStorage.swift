//
//  ToDoStorage.swift
//  To Do List
//
//  Created by Dmitry Novosyolov on 21/03/2019.
//  Copyright © 2019 Dmitry Novosyolov. All rights reserved.
//

import Foundation

class ToDoStorage
{
    static var shared = ToDoStorage()
    
    let documentDirectory = FileManager.default.urls(for:
        .documentDirectory, in: .userDomainMask).first!
    let archiveURL: URL
    
    private init() {
        archiveURL
            = documentDirectory.appendingPathComponent("todos")
                .appendingPathExtension("plist")
    }
    
    func loadToDo() -> [ToDo]?
    {
        guard let data = try? Data(contentsOf: archiveURL) else { return nil }
        
        let decoder = PropertyListDecoder()
        let decodedToDos = try? decoder.decode([ToDo].self, from: data)
        
        return decodedToDos
    }
    
    func saveToDo(todos: [ToDo])
    {
        let encoder = PropertyListEncoder()
        let encodedToDos = try? encoder.encode(todos)
        
        do
        {
            try encodedToDos?.write(to: archiveURL, options: .noFileProtection)
        }
        catch
        {
            print(#function, error.localizedDescription)
        }
    }
}
