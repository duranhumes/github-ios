//
//  Dates+Ext.swift
//  GHFollowers
//
//  Created by Duran Humes on 3/25/21.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "MMM yyyy"

        return dateFormmater.string(from: self)
    }
}
