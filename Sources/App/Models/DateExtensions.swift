//
//  DateExtensions.swift
//  App
//
//  Created by Bryan Ryczek on 12/15/18.
//

import Foundation

extension Date {
    var stringDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return formatter.string(from: self)
    }
}
