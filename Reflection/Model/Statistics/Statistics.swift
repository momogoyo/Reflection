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
  // [personal: 20, work: 15, health: 5, ...]
  let categoryStats: [CategoryStatistics]
  
  // 주별 통계 배열 (최근 7주)
  // 각 주마다 몇 개의 회고를 작성했는지
  // [이번주: 3, 지난주: 2, ...]
  let weeklyStats: [DateStatistics]
  
  // 월별 통계 배열 (최근 6개월)
  // 각 월마다 몇 개의 회고를 작성했는지
  // [8월: 12, 7월: 8, 6월: 15, ...]
  let monthlyStats: [DateStatistics]
  
  // 가장 많이 사용한 상위 태그들 (최대 10개)
  // 사용 횟수 순으로 정렬
  // [SwiftUI: 15번, 개발: 12번, 공부: 8번, ...]
  let topTags: [TagStatistics]
  
  // 최근에 작성한 회고들 (최대 5개)
  // 작성일 순으로 정렬 (최신순 정렬)
  let recentReflections: [Reflection]
  
  // MARK: - Static Methods
  
  // 회고 배열을 받아서 통계 계산
  static func calculate(from reflections: [Reflection]) -> Statistics {
    let calendar = Calendar.current
    let now = Date()
    
    // 카테고리별 통계
    let categoryGroups = Dictionary(grouping: reflections) { reflection in
      reflection.category
    }
    
    let categoryStats = categoryGroups
      .map { (category, reflectionList) in
        CategoryStatistics(
          category: category,
          count: reflectionList.count
        )
      }
      .sorted { $0.count > $1.count }
    
    // 주별 통계
    var weeklyStats: [DateStatistics] = []
    
    // 7주 전부터 오늘까지 반복
    for weekOffset in 0..<7 {
      guard let targetDate = calendar.date(byAdding: .weekOfYear, value: -weekOffset, to: now),
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: targetDate) else { continue }
      
      // 해당 주에 작성된 회고 필터
      let weekReflection = reflections
        .filter { reflection in
          weekInterval.contains(reflection.createdAt)
        }
        
      weeklyStats.append(DateStatistics(
        date: weekInterval.start, // 주의 시작일
        count: weekReflection.count // 해당 주 회고 개수
      ))
    }
    
    // 월별 통계
    var monthlyStats: [DateStatistics] = []
    
    for monthOffset in 0..<6 {
      // monthOffset개월 전의 날짜 계산
      guard let targetDate = calendar.date(byAdding: .month, value: -monthOffset, to: now),
            let monthInterval = calendar.dateInterval(of: .month, for: targetDate) else { continue }
      
      // 해당 월에 작성된 회고 필터
      let monthReflections = reflections
        .filter { reflection in
          monthInterval.contains(reflection.createdAt)
        }
      
      monthlyStats.append(
        DateStatistics(
          date: monthInterval.start, // 월의 시작일
          count: monthReflections.count // 월 회고 개수
        )
      )
    }
    
    // 태그 통계 계산
    
    // 각 회고의 태그 배열을 하나의 큰 배열로 합치기
    let allTags = reflections.flatMap { $0.tags }
  
    // 같은 태그끼리 그룹핑해서 개수 세기
    let tagGroups = Dictionary(grouping: allTags) { $0 }
    
    // 상위 10개 태그만 선택해서 TagStatistic 배열 생성
    let topTags = tagGroups
      .map { (tag, tagList) in
        TagStatistics(
          tag: tag,
          count: tagList.count
        )
      }
      .sorted { $0.count > $1.count } // 사용 횟수 많은 순서로 정렬
      .prefix(10)
    
    // 최근 5개 회고
    let recentReflections = reflections
      .sorted { $0.createdAt > $1.createdAt }
      .prefix(5)
    
    return Statistics(
      totalCount: reflections.count,
      categoryStats: categoryStats,
      weeklyStats: weeklyStats.reversed(),
      monthlyStats: monthlyStats.reversed(),
      topTags: Array(topTags),
      recentReflections: Array(recentReflections)
    )
  }
}
