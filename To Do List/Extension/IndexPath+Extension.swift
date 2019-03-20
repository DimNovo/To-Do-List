//
//  IndexPath+Extension.swift
//  To Do List
//
//  Created by Dmitry Novosyolov on 20/03/2019.
//  Copyright © 2019 Dmitry Novosyolov. All rights reserved.
//

import Foundation

extension IndexPath
{
    var nextRow: IndexPath
    {
        return IndexPath(row: self.row + 1, section: self.section)
    }
    
    var prevtRow: IndexPath
    {
        return IndexPath(row: self.row - 1, section: self.section)
    }
    
    var nextSection: IndexPath
    {
        return IndexPath(row: self.row, section: self.section + 1)
    }
    
    var prevSection: IndexPath
    {
        return IndexPath(row: self.row, section: self.section - 1)
    }
}
