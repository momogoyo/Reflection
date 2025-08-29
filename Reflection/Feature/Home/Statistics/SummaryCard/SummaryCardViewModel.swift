//
//  SummaryCardViewModel.swift
//  Reflection
//
//  Created by 현유진 on 8/28/25.
//

import Foundation

// MARK: - SummaryCardViewModel
class SummaryCardViewModel: ObservableObject {
  @Published var title: String
  @Published var summaryItems: [SummaryItem]
  @Published var isLoading: Bool = false
  
  init(
    title: String = "전체 요약",
    summaryItems: [SummaryItem] = []
  ) {
    self.title = title
    self.summaryItems = summaryItems
  }
  
  private func calculateWeeklyCount(from weeklyStats: [DateStatistics]) -> Int {
    let calendar = Calendar.current
    let now = Date()
    
    guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: now) else { return 0 }
    
    return weeklyStats.first { stat in
      calendar.isDate(
        stat.date,
        inSameDayAs: weekInterval.start
      )
    }?.count ?? 0
  }
  
  private func calculateMonthlyCount(from monthlyStats: [DateStatistics]) -> Int {
    let calendar = Calendar.current
    let now = Date()
    
    guard let monthInterval = calendar.dateInterval(of: .month, for: now) else { return 0 }
    
    return monthlyStats.first { stat in
      calendar.isDate(
        stat.date,
        inSameDayAs: monthInterval.start
      )
    }?.count ?? 0
  }
}

extension SummaryCardViewModel {
  func updateData(from statistics: Statistics) {
    self.isLoading = true
    
    // 주별, 월별 개수 계산
    let weeklyCount = self.calculateWeeklyCount(from: statistics.weeklyStats)
    let monthlyStats = self.calculateMonthlyCount(from: statistics.monthlyStats)
    
    self.summaryItems = [
      SummaryItem.ItemType.totalReflection(count: statistics.totalCount).summaryItem,
      SummaryItem.ItemType.weeklyReflection(count: weeklyCount).summaryItem,
      SummaryItem.ItemType.monthlyReflection(count: monthlyStats).summaryItem
    ]
    
    self.isLoading = false
  }
}
