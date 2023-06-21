//
//  Converter.swift
//  Users
//
//  Created by Bohdan Zhyzhchenko on 20.06.2023.
//

import Foundation

struct Converter {
    
    // Converts string from one date format to another
    static func dateFormatConvertion(from string:String) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-mm-dd'T'HH:mm:ss'Z"
        
        let date = dateFormatter.date(from: string)
        
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        guard date != nil else {
            return "none"
        }
        
        return dateFormatter.string(from:date!)
        
    }
    
}
