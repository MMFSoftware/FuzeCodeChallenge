//
//  Date+Custom.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/11/22.
//

import Foundation

extension Date {
  func custom() -> String {
    let calendar = Calendar.current
    let currentWeek = calendar.component(.weekOfYear, from: Date())
    let dateWeek = calendar.component(.weekOfYear, from: self)
    let currentYear = calendar.component(.year, from: Date())
    let dateYear = calendar.component(.year, from: self)

    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    var finalString = ""
    let today = Calendar.current.startOfDay(for: Date())
    let isToday = calendar.isDate(self, equalTo: today, toGranularity: .day)
    if dateWeek == currentWeek && dateYear == currentYear {
      if isToday {
        dateFormatter.dateFormat = "h:mm"
        let timeString = dateFormatter.string(from: self)
        let localizedTodayString = NSLocalizedString("Today", comment: "")
        finalString = "\(localizedTodayString), \(timeString)"
      } else {
        dateFormatter.dateFormat = "EEE, h:mm"
        finalString = dateFormatter.string(from: self)
      }
    } else {
      dateFormatter.dateFormat = "MM.dd.yy, h:mm"
      let timeString = dateFormatter.string(from: self)
      finalString = "\(timeString)"
    }

    return finalString
  }

  static let iso8601Full: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
