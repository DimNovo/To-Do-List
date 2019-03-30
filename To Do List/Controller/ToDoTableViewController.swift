//
//  ToDoTableViewController.swift
//  To Do List
//
//  Created by Dmitry Novosyolov on 11/03/2019.
//  Copyright © 2019 Dmitry Novosyolov. All rights reserved.
//

import UIKit

// MARK: - ... Properties
class ToDoTableViewController: UITableViewController
{
    var todos = [ToDo]()
    {
        didSet
        {
            print("todos is changed: \(todos.self)")
        }
    }
}

// MARK: - ... UIViewController Methods
extension ToDoTableViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ToDo.loadFromCloudKit { todos in
            if let todos = todos
            {
                self.todos = todos //ToDo.loadFromCloud
            }
            else
            {
                self.todos = [] //ToDo.loadSampleData()
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - ... Navigation
extension ToDoTableViewController
{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ToDoItemSegue" else { return }
        guard let index = tableView.indexPathForSelectedRow?.row else { return }
        
        let todo = todos[index]
        let destination = segue.destination as! ToDoItemTableViewController
        destination.todo = todo
        destination.navigationItem.title = "Edit"
    }
    // MARK: - ... Unwind Segue
    @IBAction func unwind(segue: UIStoryboardSegue)
    {
        guard segue.identifier == "SaveSegue" else { return }
        let source = segue.source as! ToDoItemTableViewController
        let todo = source.todo
        guard !(source.todo.title.isEmpty) else { return }
        // Edited Cell
        if source.navigationItem.title == "Edit",
            let indexPath = tableView.indexPathForSelectedRow
        {
            todos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
            
            // Aded Cell
        else if source.navigationItem.title == "Add"
        {
            let indexPath = IndexPath(row: todos.count, section: 0)
            todos.append(todo)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - ... TableViewDelegate
extension ToDoTableViewController
{
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        // Delete Cell
        let delete = UITableViewRowAction(style: .destructive, title: "DELETE")
        {
            (action, indexPath) in
            self.todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        // Copy Cell
        let insert = UITableViewRowAction(style: .normal, title: "COPY")
        {
            (action, indexPath) in
            let todoToCopy = self.todos[indexPath.row]
            self.todos.insert(todoToCopy, at: indexPath.row)
            tableView.insertRows(at: [indexPath], with: .bottom)
        }
        
        delete.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        insert.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        return [delete, insert]
    }
}

// MARK: - ... TableViewDataSource
extension ToDoTableViewController
{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell")!
        let row = indexPath.row
        let todo = todos[row]
        configure(cell: cell, with: todo)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return todos.count
    }
}

// MARK: - ... Custom Methods
extension ToDoTableViewController
{
    func configure(cell: UITableViewCell, with todo: ToDo)
    {
        cell.textLabel?.text = todo.title
        
        let formater = DateFormatter()
        formater.timeStyle = .none
        formater.dateStyle = .medium
        let dateText = formater.string(from: todo.dueDate)
        
        cell.detailTextLabel?.text = dateText
    }
}
