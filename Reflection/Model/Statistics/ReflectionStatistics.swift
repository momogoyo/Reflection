//
//  Statustics.swift
//  Reflection
//
//  Created by 현유진 on 8/22/25.
//

import Foundation
import SwiftData

// MARK: - 통계 데이터 모델
struct ReflectionStatistics {
  let totalCount: Int
  let categoryStats: [ReflectionCategory: Int]
  let weeklyStats: [Date: Int]
  let monthlyStats: [Date: Int]
  let topTags: [(tag: String, count: Int)]
  let recentReflections: [Reflection]
  
  static func calculate(from reflections: [Reflection]) -> ReflectionStatistics {
    let calendar = Calendar.current
    let now = Date()
    
    // 카테고리별 통계
    let categoryStats = Dictionary(grouping: reflections, by: { $0.category })
      .mapValues { $0.count }
    
    // 주별 통계 (최근 8주)
    var weeklyStats: [Date: Int] = [:]
    for i in 0..<8 {
      if let weekStart = calendar.dateInterval(of: .weekOfYear, for: calendar.date(byAdding: .weekOfYear, value: -i, to: now)!)?.start {
        let weekReflections = reflections.filter { reflection in
          calendar.isDate(reflection.createdAt, inSameDayAs: weekStart) ||
          (reflection.createdAt >= weekStart && reflection.createdAt < calendar.date(byAdding: .weekOfYear, value: 1, to: weekStart)!)
        }
        weeklyStats[weekStart] = weekReflections.count
      }
    }
    
    // 월별 통계 (최근 6개월)
    var monthlyStats: [Date: Int] = [:]
    for i in 0..<6 {
      if let monthStart = calendar.dateInterval(of: .month, for: calendar.date(byAdding: .month, value: -i, to: now)!)?.start {
        let monthReflections = reflections.filter { reflection in
          calendar.isDate(reflection.createdAt, equalTo: monthStart, toGranularity: .month)
        }
        monthlyStats[monthStart] = monthReflections.count
      }
    }
    
    // 태그 통계 (상위 10개)
    let allTags = reflections.flatMap { $0.tags }
    let tagCounts = Dictionary(grouping: allTags, by: { $0 })
      .mapValues { $0.count }
    let topTags = tagCounts
      .sorted { $0.value > $1.value }
      .prefix(10)
      .map { (tag: $0.key, count: $0.value) }
    
    // 최근 회고 (최근 5개)
    let recentReflections = reflections
      .sorted { $0.createdAt > $1.createdAt }
      .prefix(5)
      .map { $0 }
    
    return ReflectionStatistics(
      totalCount: reflections.count,
      categoryStats: categoryStats,
      weeklyStats: weeklyStats,
      monthlyStats: monthlyStats,
      topTags: Array(topTags),
      recentReflections: Array(recentReflections)
    )
  }
}
