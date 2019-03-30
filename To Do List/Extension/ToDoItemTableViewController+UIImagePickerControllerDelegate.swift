//
//  ToDoItemTableViewController+UIImagePickerControllerDelegate.swift
//  To Do List
//
//  Created by Dmitry Novosyolov on 25/03/2019.
//  Copyright © 2019 Dmitry Novosyolov. All rights reserved.
//

import UIKit

extension ToDoItemTableViewController: UIImagePickerControllerDelegate
{
        
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info:
                                [UIImagePickerController.InfoKey : Any])
    {
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: indexPath!) as! ImageCell
        
        if picker.allowsEditing
        {
            let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
            cell.largeImageView.image = pickedImage
            print(#function, "image to save: \(pickedImage)")
        }
        else
        {
            let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            cell.largeImageView.image = pickedImage
            print(#function, "image to save: \(pickedImage)")
        }

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
}
