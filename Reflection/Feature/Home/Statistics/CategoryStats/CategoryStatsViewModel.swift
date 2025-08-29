//
//  CategoryStatsViewModel.swift
//  Reflection
//
//  Created by 현유진 on 8/28/25.
//

import Foundation

// MARK: - 카테고리별 통계 모델
class CategoryStatsViewModel: ObservableObject {
  @Published var title: String
  @Published var categoryStats: [CategoryStatistics]
  @Published var totalCount: Int
  @Published var isLoading: Bool = false
  
  init(
    title: String = "카테고리별 분포",
    categoryStats: [CategoryStatistics] = [],
    totalCount: Int = 0
  ) {
    self.title = title
    self.categoryStats = categoryStats
    self.totalCount = totalCount
  }
  
  var isEmpty: Bool {
    categoryStats.allSatisfy({ $0.count == 0 })
  }
}

extension CategoryStatsViewModel {
  func updateData(from statistics: Statistics) {
    self.isLoading = true
    
    self.totalCount = statistics.totalCount
    
    self.categoryStats = ReflectionCategory.allCases.map { category in
      let categoryStatistic = statistics.categoryStats.first { $0.category == category }
      let count = categoryStatistic?.count ?? 0
      
      return CategoryStatistics(
        category: category,
        count: count
      )
    }
    
    self.categoryStats.sort { $0.count > $1.count }
    
    self.isLoading = false
  }
  
  func setEmptyData() {
    self.categoryStats = ReflectionCategory.allCases.map { category in
      CategoryStatistics(category: category, count: 0)
    }
  }
}
