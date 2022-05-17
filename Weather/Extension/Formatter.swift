//
//  Formatter.swift
//  Weather
//
//  Created by Michal Červenec on 26/04/2022.
//

import Foundation

extension DateFormatter {
    
    static let dayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter
    } ()
}
