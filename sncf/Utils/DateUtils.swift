//
//  dateUtils.swift
//  sncf
//
//  Created by Martin Voigt on 29.10.20.
//

import Foundation

// Get "12h13" string from Date object
func getHourAndMinute(date: Date) -> String {
    let hourDateFormatter = DateFormatter()
    let minuteDateFormatter = DateFormatter()
    hourDateFormatter.dateFormat = "HH"
    minuteDateFormatter.dateFormat = "mm"
    
    return hourDateFormatter.string(from: date) + "h" + minuteDateFormatter.string(from: date)
    
}

// Get "12/03/2020" string from Date object
func getDateString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    
    return dateFormatter.string(from: date)
}
