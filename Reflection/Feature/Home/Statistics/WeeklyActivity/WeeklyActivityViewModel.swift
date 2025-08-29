//
//  WeeklyActivityViewModel.swift
//  Reflection
//
//  Created by 현유진 on 8/28/25.
//

import Foundation

class WeeklyActivityViewModel: ObservableObject {
  @Published var title: String
  @Published var weeklyData: [DateStatistics]
  @Published var isLoading: Bool = false
  
  init(
    title: String = "주별 활동 (최근 8주)",
    weeklyData: [DateStatistics] = []
  ) {
    self.title = title
    self.weeklyData = weeklyData
  }
  
  var isEmpty: Bool {
    return weeklyData.isEmpty || weeklyData.allSatisfy { $0.count == 0 }
  }
}

extension WeeklyActivityViewModel {
  func updateData(from statistics: Statistics) {
    self.isLoading = true
    
    self.weeklyData = statistics.weeklyStats.sorted { $0.date < $1.date }
    
    self.isLoading = false
  }
  
  func setupEmptyData() {
    self.weeklyData = []
  }
}
