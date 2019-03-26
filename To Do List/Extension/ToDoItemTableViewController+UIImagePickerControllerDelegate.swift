//
//  ToDoItemTableViewController+UIImagePickerControllerDelegate.swift
//  To Do List
//
//  Created by Dmitry Novosyolov on 25/03/2019.
//  Copyright © 2019 Dmitry Novosyolov. All rights reserved.
//

import UIKit

extension ToDoItemTableViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: indexPath!) as! ImageCell
        
        cell.largeImageView.image = image
        
        print(#function, "image to save: \(image)")
        dismiss(animated: true)
    }
}
