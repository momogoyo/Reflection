//
//  StatisticsTypes.swift
//  Reflection
//
//  Created by 현유진 on 8/26/25.
//

import Foundation

// MARK: - 통계 관련 타입

// 태그와 사용된 횟수
// - tag: 태그 이름
// - count: 해당 태그가 사용된 횟수
struct TagStatistics {
  let tag: String
  let count: Int
}

// 날짜별 회고 작성 통계 타입
// - date: 통계 기준 날짜 (주의 시작일 또는 월의 시작일)
// - count: 해당 기간에 작성된 회고 개수
struct DateStatistics {
  let date: Date
  let count: Int
}

// 카테고리별 회고 통계 타입
// - category: 회고 카테고리
// - count: 해당 카테고리의 회고 개수
struct CategoryStatistics {
  let category: ReflectionCategory
  let count: Int
}
