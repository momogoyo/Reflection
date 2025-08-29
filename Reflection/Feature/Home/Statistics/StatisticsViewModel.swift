//
//  StatisticsViewModel.swift
//  Reflection
//
//  Created by 현유진 on 8/28/25.
//

import Foundation
import SwiftUI

// MARK: - 통계 뷰 모델
class StatisticsViewModel: ObservableObject {
  @Published var statistics: Statistics
  @Published var isLoading: Bool = false
  
  init() {
    self.statistics = Statistics(
      totalCount: 0,
      categoryStats: [],
      weeklyStats: [],
      monthlyStats: [],
      topTags: [],
      recentReflections: []
    )
  }
}

extension StatisticsViewModel {
  func updateStatistics(from reflection: [Reflection]) {
    self.isLoading = true
    
    self.statistics = Statistics.calculate(from: reflection)
    
    self.isLoading = false
  }
  
  // 빈 통계로 초기화
  func resetStatistics() {
    self.statistics = Statistics(
      totalCount: 0,
      categoryStats: [],
      weeklyStats: [],
      monthlyStats: [],
      topTags: [],
      recentReflections: []
    )
  }
}
