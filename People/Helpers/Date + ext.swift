//
//  Date + ext.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//

import Foundation

extension Date {
    func toString(format: String, timeZoneOffset: Int = 3) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timeZoneOffset * 3600)
        return dateFormatter.string(from: self)
    }

    static func toDateFrom(_ string: String, format: String, timeZoneOffset: Int = 3) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timeZoneOffset * 3600)
        return dateFormatter.date(from: string)
    }
}
