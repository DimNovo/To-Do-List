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
}

// MARK: - ... UIViewController Methods
extension ToDoTableViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        todos = ToDo.loadData() ?? []
    }
}

// MARK: - ... Navigation
extension ToDoTableViewController {
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
