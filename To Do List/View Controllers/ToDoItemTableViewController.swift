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
    var todo = ToDo()
}

// MARK: - ... TableViewDataSource
extension ToDoItemTableViewController/*: TableViewDataSource */
{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = indexPath.section
        let value = todo.values[section]
        let cell = configureCellFor(indexPath: indexPath, with: value)
        
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
        let value = todo.values[section]
        let numberOfRows = value is Date ? 2 : 1
        return numberOfRows
    }
}

// MARK: - ... UITableViewDelegate
extension ToDoItemTableViewController/*: UITableViewDelegate */
{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard isItDateCell(at: indexPath) else { return }
        guard let cell = tableView.cellForRow(at: indexPath.nextRow) else { return }
        
        cell.isHidden.toggle()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        guard isItDatePickerCell(at: indexPath) else { return 44 }
        guard let cell = tableView.cellForRow(at: indexPath) else { return 44 }
        return cell.isHidden ? 0 : 200
    }
}

// MARK: - ... Custom Methods
extension ToDoItemTableViewController
{
    // Checking: is DateCell
    func isItDateCell(at indexPath: IndexPath) -> Bool
    {
        guard let cell = tableView.cellForRow(at: indexPath) else { return false }
        
        return cell is DateCell
    }
    // Checking: is DatePickerCell
    func isItDatePickerCell(at indexPath: IndexPath) -> Bool
    {
        guard let cell = tableView.cellForRow(at: indexPath) else { return false }
        
        return cell is DatePickerCell
    }
    
    // Configure: Cell
    func configureCellFor(indexPath: IndexPath, with value: Any?) -> UITableViewCell
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
                    switch indexPath.row
                    {
                        
                    case 0:
                        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell") as! DateCell
                        cell.setDate(dateValue)
                        
                        return cell
                        
                    default:
                        let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell") as! DatePickerCell
                        cell.datePicker.addTarget(self, action: #selector(valueChanged(at:)), for: .valueChanged)
                        cell.datePicker.date = Date()
                        cell.datePicker.indexPath = indexPath
                        cell.datePicker.minimumDate = Date()
                        cell.isHidden = true
                        
                        return cell
                    }
                }
                else
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
                    cell.textField.text = nil
                    
                    return cell
        }
    }
    
    @objc func valueChanged(at datePicker: DatePicker)
    {
        let dateCellIndexPath = datePicker.indexPath.prevtRow
        guard let cell = tableView.cellForRow(at: dateCellIndexPath) as? DateCell else { return }
        cell.setDate(datePicker.date)
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
