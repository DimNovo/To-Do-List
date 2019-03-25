//
//  UIImageView+Extension.swift
//  To Do List
//
//  Created by Dmitry Novosyolov on 25/03/2019.
//  Copyright © 2019 Dmitry Novosyolov. All rights reserved.
//

import UIKit

extension UIImageView
{
    func roundImage()
    {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
