//
//  SummaryItem.swift
//  Reflection
//
//  Created by 현유진 on 8/28/25.
//

import Foundation
import SwiftUI

// MARK: - 요약 항목 모델
struct SummaryItem: Hashable {
  let title: String
  let value: String
  let icon: String
  let color: Color
  
  init(
    title: String,
    value: String,
    icon: String,
    color: Color
  ) {
    self.title = title
    self.value = value
    self.icon = icon
    self.color = color
  }
  
  // 편의 생성자
  init(
    title: String,
    count: Int,
    icon: String,
    color: Color
  ) {
    self.title = title
    self.value = "\(count)개"
    self.icon = icon
    self.color = color
  }
}

// MARK: - 요약 항목 타입
extension SummaryItem {
  enum ItemType {
    case totalReflection(count: Int)
    case weeklyReflection(count: Int)
    case monthlyReflection(count: Int)
    
    var summaryItem: SummaryItem {
      switch self {
      case .totalReflection(let count):
        return SummaryItem(
          title: "총 회고",
          count: count,
          icon: "book.fill",
          color: .blue
        )
        
      case .weeklyReflection(let count):
        return SummaryItem(
          title: "이번 주",
          count: count,
          icon: "calendar",
          color: .green
        )
        
      case .monthlyReflection(let count):
        return SummaryItem(
          title: "이번 달",
          count: count,
          icon: "calendar.badge.clock",
          color: .orange
        )
      }
    }
  }
}

