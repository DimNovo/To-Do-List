//
//  ToDoItemTableViewController.swift
//  To Do List
//
//  Created by Dmitry Novosyolov on 11/03/2019.
//  Copyright © 2019 Dmitry Novosyolov. All rights reserved.
//

import UIKit

class ToDoItemTableViewController: UITableViewController
{
    
    private var todo = ToDo(title: String(), isComplete: Bool(), dueDate: Date(), notes: nil)

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return todo.keys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")!
        
        let row = indexPath.row
        let key = todo.keys[row]
        
        configure(cell: cell, with: key)
        return cell
    }
    
    func configure(cell: UITableViewCell, with key: String)
    {
        cell.textLabel?.text = key
    }
}
