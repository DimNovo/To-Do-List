//
//  DateCell.swift
//  To Do List
//
//  Created by Dmitry Novosyolov on 14/03/2019.
//  Copyright © 2019 Dmitry Novosyolov. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell
{

    @IBOutlet weak var labelCell: UILabel!
    
    func setDate(_ date: Date)
    {
        let formater = DateFormatter()
        formater.dateStyle = .medium
        formater.timeStyle = .short
        formater.dateFormat = "d/MM/y  HH:mm"
        labelCell.text = formater.string(from: date)
    }
}
