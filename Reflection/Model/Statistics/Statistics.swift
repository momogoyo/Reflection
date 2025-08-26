//
//  Statustics.swift
//  Reflection
//
//  Created by 현유진 on 8/22/25.
//

import Foundation
import SwiftData

// MARK: - 회고 통계 데이터 모델
// 사용자의 회고 작성 패턴 등을 분석하기 위한 데이터 포함
struct Statistics {
  // 전체 회고 개수
  let totalCount: Int
  
  // 카테고리별 통계 배열로 저장
  // [personal: 20, work: 15, health: 5 ...]
  let categoryStats: [CategoryStatistics]
  
  // 주별 통계 배열 (최근 8주)
  // 각 주마다 몇 개의 회고를 작성했는지
  // [이번주: 3, 지난주: 2 ...]
  let weeklyStats: [DateStatistics]
  
  // 월별 통계 배열 (최근 6개월)
  // 각 월마다 몇 개의 회고를 작성했는지
  // [8월: 12, 7월: 8, 6월: 15]
  let monthlyStats: [DateStatistics]
  let topTags: [TagStatistics]
  let recentReflections: [Reflection]
  
  static func calculate(from reflections: [Reflection]) -> Statistics {
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
    
    return Statistics(
      totalCount: reflections.count,
      categoryStats: categoryStats,
      weeklyStats: weeklyStats,
      monthlyStats: monthlyStats,
      topTags: Array(topTags),
      recentReflections: Array(recentReflections)
    )
  }
}
