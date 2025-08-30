//
//  Date+Extension.swift
//  Reflection
//
//  Created by 현유진 on 8/23/25.
//

import Foundation

extension Date {
  var formatted: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy.MM.dd" // , a h:mm
    
    return formatter.string(from: self)
  }
}
