//
//  String+Extension.swift
//  To Do List
//
//  Created by Dmitry Novosyolov on 20/03/2019.
//  Copyright © 2019 Dmitry Novosyolov. All rights reserved.
//

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
