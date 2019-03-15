//
//  ToDoItemTableViewController.swift
//  To Do List
//
//  Created by Dmitry Novosyolov on 11/03/2019.
//  Copyright © 2019 Dmitry Novosyolov. All rights reserved.
//

import UIKit

// MARK: - ... Properties
class ToDoItemTableViewController: UITableViewController
{
    //    enum CellType
    //    {
    //        case
    //        DateCell,
    //        NotesCell,
    //        SwitchCell,
    //        TextFieldCell
    //    }
    
    var todo = ToDo()
}

// MARK: - ... TableViewDataSource
extension ToDoItemTableViewController
{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = indexPath.section
        let value = todo.values[section]
        
        let cell = configureCell(with: value)
        return cell
    }
    
    // Header Title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let key = todo.keys[section]
        return key
    }
    // Header Title Customizing
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        header.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        header.textLabel?.text = todo.keys[section].titlecased()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return todo.keys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
}

// MARK: - ... Custom Methods
extension ToDoItemTableViewController
{
    func configureCell(with value: Any?) -> UITableViewCell
    {
        if let stringValue = value as? String
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.textField.text = stringValue
            
            return cell
        }
        else
            if let boolValue = value as? Bool
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
                cell.switchCell.isOn = boolValue
                
                return cell
            }
            else
                if let dateValue = value as? Date
                {
                    let formater = DateFormatter()
                    formater.dateStyle = .medium
                    formater.timeStyle = .short
                    formater.dateFormat = "d/MM/y  HH:mm"
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell") as! DateCell
                    cell.labelCell.text = formater.string(from: dateValue)
                    
                    return cell
                }
                else
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
                    cell.textField.text = nil
                    
                    return cell
        }
    }
}

// MARK: - ... Navigation
extension ToDoItemTableViewController
{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        guard segue.identifier == "SaveSegue" else { return }
        
        for (index, key) in todo.keys.enumerated()
        {
            
            let indexPath = IndexPath(row: 0, section: index)
            let cell = tableView.cellForRow(at: indexPath)
            let value = todo.values[index]
            
            if value is String
            {
                let textFieldCell = cell as! TextFieldCell
                let value = textFieldCell.textField.text
                todo.setValue(value, forKey: key)
                
            }
            else if value is Bool
            {
                let switchCell = cell as! SwitchCell
                let value = switchCell.switchCell.isOn
                todo.setValue(value, forKey: key)
                
            }
            else if value is Date
            {
                let formater = DateFormatter()
                formater.dateStyle = .medium
                formater.timeStyle = .short
                formater.dateFormat = "d/MM/y  HH:mm"
                
                let dateCell = cell as! DateCell
                let text = dateCell.labelCell.text ?? ""
                let value = formater.date(from: text)
                todo.setValue(value, forKey: key)
                
            }
            else
            {
                let textFieldCell = cell as! TextFieldCell
                let value = textFieldCell.textField.text
                todo.setValue(value, forKey: key)
            }
        }
    }
}

// MARK: - ... Extension: String Methods
extension String
{
    func titlecased() -> String
    {
        let title = self.replacingOccurrences(
            of: "([A-Z])", with: " $1", options:
            .regularExpression, range: self.range(
                of: self)).localizedCapitalized
        
        return title
    }
}
