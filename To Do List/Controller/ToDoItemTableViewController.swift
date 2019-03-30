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
    // MARK: - ... Outlets
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: - ... Properties
    var todo = ToDo()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        saveButton.isEnabled = false
    }
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
        if  isItDateCell(at: indexPath)
        {
            tableView.deselectRow(at: indexPath, animated: true)
            guard let cell = tableView.cellForRow(at: indexPath.nextRow) else { return }
            cell.isHidden.toggle()
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        else if isItImageCell(at: indexPath)
        {
            let cell = tableView.cellForRow(at: indexPath) as! ImageCell
            camera(sender: cell)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        guard let cell = tableView.cellForRow(at: indexPath),
            isItDatePickerCell(at: indexPath) || isItImageCell(at: indexPath)
            else { return 44 }
        return cell.isHidden ? 0 : 200
    }
}

// MARK: - ... Custom Methods
extension ToDoItemTableViewController
{
    func camera(sender: ImageCell)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(
            title: "𝐏𝐥𝐞𝐚𝐬𝐞 𝐂𝐡𝐨𝐨𝐬𝐞 𝐈𝐦𝐚𝐠𝐞 𝐒𝐨𝐮𝐫𝐜𝐞:",
            message: nil,
            preferredStyle: .alert)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let cameraAction = UIAlertAction(title: "𝐂𝐚𝐦𝐞𝐫𝐚", style: .default)
            { action in
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            let photoLibraryAction = UIAlertAction(title: "𝐏𝐡𝐨𝐭𝐨 𝐋𝐢𝐛𝐫𝐚𝐫𝐲", style: .default)
            { action in
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(photoLibraryAction)
        }
        
        let cancelAction = UIAlertAction(title: "𝐂𝐀𝐍𝐂𝐄𝐋", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        
        // For iPad UI
        alertController.popoverPresentationController?.sourceView = sender
        
        self.present(alertController, animated: true, completion: nil)
    }
    
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
    // Checking: is ImageCell
    func isItImageCell(at indexPath: IndexPath) -> Bool
    {
        guard let cell = tableView.cellForRow(at: indexPath) else { return false }
        return cell is ImageCell
    }
    
    // Configure: Cell
    func configureCellFor(indexPath: IndexPath, with value: Any?) -> UITableViewCell
    {
        switch value
        {
        case is String:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.textField.addTarget(self, action: #selector(ToDoItemTableViewController
                .textFieldDidChanged(_:)), for: UIControl.Event.editingChanged)
            cell.textField.text = value as? String
            return cell
            
        case is Bool:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            cell.switchCell.isOn = (value != nil)
            return cell
            
        case is Date:
            switch indexPath.row
            {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell") as! DateCell
                cell.setDate(value as! Date)
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
            
        case is UIImage:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell
            cell.largeImageView.image = UIImage(named: "default") ?? value as? UIImage
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.textField.text = value as? String
            print(#function, "Can't find cell type at line: \(#line)")
            return cell
        }
    }
    
    // objc dinamic datePicker check
    @objc func valueChanged(at datePicker: DatePicker)
    {
        let dateCellIndexPath = datePicker.indexPath.prevtRow
        guard let cell = tableView.cellForRow(at: dateCellIndexPath) as? DateCell else { return }
        cell.setDate(datePicker.date)
    }
    
    // objc dinamic textField check
    @objc func textFieldDidChanged(_ textField: UITextField)
    {
        print(#function, "textFieldDidChanged: \(textField.text ?? "nil")")
        if  !textField.text!.isEmpty
        {
            saveButton.isEnabled = true
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
            
            switch value
            {
            case is String:
                let textFieldCell = cell as! TextFieldCell
                let value = textFieldCell.textField.text
                todo.setValue(value, forKey: key)
                
            case is Bool:
                let switchCell = cell as! SwitchCell
                let value = switchCell.switchCell.isOn
                todo.setValue(value, forKey: key)
                
            case is Date:
                let formater = DateFormatter()
                formater.dateStyle = .medium
                formater.timeStyle = .short
                formater.dateFormat = "d/MM/y  HH:mm"
                
                let dateCell = cell as! DateCell
                let text = dateCell.labelCell.text ?? ""
                let value = formater.date(from: text)
                todo.setValue(value, forKey: key)
                
            case is UIImage:
                let ImageCell = cell as! ImageCell
                let value = ImageCell.largeImageView?.image
                todo.setValue(value, forKey: key)
                
            default:
                let textFieldCell = cell as! TextFieldCell
                let value = textFieldCell.textField.text
                todo.setValue(value, forKey: key)
                print(#function, "Can't find cell type at line: \(#line)")
            }
        }
        print(#function, todo.values)
        ToDo.saveToCloudKit { todo in guard todo != nil else { return } }
    }
}
