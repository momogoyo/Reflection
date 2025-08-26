//
//  StatisticsView.swift
//  Reflection
//
//  Created by 현유진 on 8/22/25.
//

import SwiftUI

import SwiftData
import Charts

// MARK: - 통계 뷰
struct StatisticsView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Reflection.createdAt, order: .reverse) private var reflections: [Reflection]
  @AppStorage("fontSize") private var fontSize = 16.0
  
  private var statistics: ReflectionStatistics {
    ReflectionStatistics.calculate(from: reflections)
  }
  
  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVStack(spacing: 20) {
          // 전체 요약
          SummaryCardView(statistics: statistics)
          
          // 카테고리별 통계
          CategoryStatsView(statistics: statistics)
          
          // 주별 활동 차트
          WeeklyActivityView(statistics: statistics)
          
          // 월별 활동 차트
          MonthlyActivityView(statistics: statistics)
          
          // 인기 태그
          PopularTagsView(statistics: statistics)
          
          // 최근 회고
          RecentReflectionsView(statistics: statistics)
        }
        .padding()
      }
      .navigationTitle("통계")
    }
    .font(.system(size: fontSize))
  }
}

// MARK: - 요약 카드
struct SummaryCardView: View {
  let statistics: ReflectionStatistics
  
  var body: some View {
    VStack(spacing: 16) {
      HStack {
        Text("전체 요약")
          .font(.headline)
        Spacer()
      }
      
      HStack(spacing: 20) {
        StatItemView(
          title: "총 회고",
          value: "\(statistics.totalCount)개",
          icon: "book.fill",
          color: .blue
        )
        
        StatItemView(
          title: "이번 주",
          value: "\(weeklyCount)개",
          icon: "calendar",
          color: .green
        )
        
        StatItemView(
          title: "이번 달",
          value: "\(monthlyCount)개",
          icon: "calendar.badge.clock",
          color: .orange
        )
      }
    }
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(12)
  }
  
  private var weeklyCount: Int {
    let calendar = Calendar.current
    let now = Date()
    guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start else { return 0 }
    return statistics.weeklyStats[weekStart] ?? 0
  }
  
  private var monthlyCount: Int {
    let calendar = Calendar.current
    let now = Date()
    guard let monthStart = calendar.dateInterval(of: .month, for: now)?.start else { return 0 }
    return statistics.monthlyStats[monthStart] ?? 0
  }
}

// MARK: - 통계 아이템
struct StatItemView: View {
  let title: String
  let value: String
  let icon: String
  let color: Color
  
  var body: some View {
    VStack(spacing: 8) {
      Image(systemName: icon)
        .font(.title2)
        .foregroundColor(color)
      
      Text(value)
        .font(.title3.weight(.bold))
      
      Text(title)
        .font(.caption)
        .foregroundColor(.secondary)
    }
    .frame(maxWidth: .infinity)
  }
}

// MARK: - 카테고리별 통계
struct CategoryStatsView: View {
  let statistics: ReflectionStatistics
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("카테고리별 분포")
        .font(.headline)
      
      ForEach(ReflectionCategory.allCases, id: \.self) { category in
        let count = statistics.categoryStats[category] ?? 0
        let percentage = statistics.totalCount > 0 ? Double(count) / Double(statistics.totalCount) : 0.0
        
        CategoryRowView(
          category: category,
          count: count,
          percentage: percentage
        )
      }
    }
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(12)
  }
}

// MARK: - 카테고리 행
struct CategoryRowView: View {
  let category: ReflectionCategory
  let count: Int
  let percentage: Double
  
  var body: some View {
    HStack {
      Image(systemName: category.icon)
        .foregroundColor(Color(category.color))
        .frame(width: 20)
      
      Text(category.rawValue)
        .font(.subheadline)
      
      Spacer()
      
      Text("\(count)개")
        .font(.subheadline.weight(.medium))
        .foregroundColor(.secondary)
    }
    .padding(.vertical, 4)
    
    ProgressView(value: percentage, total: 1.0)
      .progressViewStyle(LinearProgressViewStyle(tint: Color(category.color)))
      .scaleEffect(y: 0.8)
  }
}

// MARK: - 주별 활동 차트
struct WeeklyActivityView: View {
  let statistics: ReflectionStatistics
  
  private var weeklyData: [(date: Date, count: Int)] {
    statistics.weeklyStats
      .sorted { $0.key < $1.key }
      .map { (date: $0.key, count: $0.value) }
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("주별 활동 (최근 8주)")
        .font(.headline)
      
      if !weeklyData.isEmpty {
        Chart(weeklyData, id: \.date) { item in
          BarMark(
            x: .value("주", item.date, unit: .weekOfYear),
            y: .value("회고 수", item.count)
          )
          .foregroundStyle(.blue.gradient)
          .cornerRadius(4)
        }
        .frame(height: 180)
        .chartXAxis {
          AxisMarks(values: .stride(by: .weekOfYear)) { value in
            if let date = value.as(Date.self) {
              AxisValueLabel {
                Text(date, format: .dateTime.month(.abbreviated).day())
                  .font(.caption)
              }
            }
          }
        }
        .chartYAxis {
          AxisMarks { value in
            AxisValueLabel {
              if let intValue = value.as(Int.self) {
                Text("\(intValue)")
                  .font(.caption)
              }
            }
          }
        }
      } else {
        Text("데이터가 없습니다")
          .foregroundColor(.secondary)
          .frame(height: 100)
          .frame(maxWidth: .infinity)
      }
    }
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(12)
  }
}

// MARK: - 월별 활동 차트
struct MonthlyActivityView: View {
  let statistics: ReflectionStatistics
  
  private var monthlyData: [(date: Date, count: Int)] {
    statistics.monthlyStats
      .sorted { $0.key < $1.key }
      .map { (date: $0.key, count: $0.value) }
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("월별 활동 (최근 6개월)")
        .font(.headline)
      
      if !monthlyData.isEmpty {
        Chart(monthlyData, id: \.date) { item in
          LineMark(
            x: .value("월", item.date, unit: .month),
            y: .value("회고 수", item.count)
          )
          .foregroundStyle(.green)
          .lineStyle(StrokeStyle(lineWidth: 3))
          .symbol(Circle().strokeBorder(lineWidth: 2))
          .symbolSize(50)
          
          AreaMark(
            x: .value("월", item.date, unit: .month),
            y: .value("회고 수", item.count)
          )
          .foregroundStyle(.green.opacity(0.2))
        }
        .frame(height: 180)
        .chartXAxis {
          AxisMarks(values: .stride(by: .month)) { value in
            if let date = value.as(Date.self) {
              AxisValueLabel {
                Text(date, format: .dateTime.month(.abbreviated))
                  .font(.caption)
              }
            }
          }
        }
        .chartYAxis {
          AxisMarks { value in
            AxisValueLabel {
              if let intValue = value.as(Int.self) {
                Text("\(intValue)")
                  .font(.caption)
              }
            }
          }
        }
      } else {
        Text("데이터가 없습니다")
          .foregroundColor(.secondary)
          .frame(height: 100)
          .frame(maxWidth: .infinity)
      }
    }
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(12)
  }
}

// MARK: - 인기 태그
struct PopularTagsView: View {
  let statistics: ReflectionStatistics
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("인기 태그")
        .font(.headline)
      
      if !statistics.topTags.isEmpty {
        LazyVGrid(columns: [
          GridItem(.adaptive(minimum: 100))
        ], alignment: .leading, spacing: 8) {
          ForEach(Array(statistics.topTags.enumerated()), id: \.offset) { index, tagData in
            TagRankView(
              rank: index + 1,
              tag: tagData.tag,
              count: tagData.count
            )
          }
        }
      } else {
        Text("태그가 없습니다")
          .foregroundColor(.secondary)
          .frame(maxWidth: .infinity, alignment: .center)
          .padding()
      }
    }
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(12)
  }
}

// MARK: - 태그 순위
struct TagRankView: View {
  let rank: Int
  let tag: String
  let count: Int
  
  private var rankColor: Color {
    switch rank {
    case 1: return .yellow
    case 2: return .gray
    case 3: return .orange
    default: return .blue
    }
  }
  
  var body: some View {
    HStack(spacing: 8) {
      Text("\(rank)")
        .font(.caption.weight(.bold))
        .foregroundColor(.white)
        .frame(width: 20, height: 20)
        .background(rankColor)
        .clipShape(Circle())
      
      VStack(alignment: .leading, spacing: 2) {
        Text("#\(tag)")
          .font(.subheadline.weight(.medium))
          .lineLimit(1)
        
        Text("\(count)회")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      
      Spacer(minLength: 0)
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 8)
    .background(Color(.systemBackground))
    .cornerRadius(8)
    .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
  }
}

// MARK: - 최근 회고
struct RecentReflectionsView: View {
  let statistics: ReflectionStatistics
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("최근 회고")
        .font(.headline)
      
      if !statistics.recentReflections.isEmpty {
        ForEach(statistics.recentReflections, id: \.id) { reflection in
          RecentReflectionRowView(reflection: reflection)
        }
      } else {
        Text("회고가 없습니다")
          .foregroundColor(.secondary)
          .frame(maxWidth: .infinity, alignment: .center)
          .padding()
      }
    }
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(12)
  }
}

// MARK: - 최근 회고 행
struct RecentReflectionRowView: View {
  let reflection: Reflection
  
  var body: some View {
    HStack(spacing: 12) {
      Image(systemName: reflection.category.icon)
        .foregroundColor(Color(reflection.category.color))
        .frame(width: 24, height: 24)
      
      VStack(alignment: .leading, spacing: 4) {
        Text(reflection.title)
          .font(.subheadline.weight(.medium))
          .lineLimit(1)
        
        Text(reflection.createdAt, style: .relative)
          .font(.caption)
          .foregroundColor(.secondary)
      }
      
      Spacer()
      
      Image(systemName: "chevron.right")
        .font(.caption)
        .foregroundColor(.secondary)
    }
    .padding(.vertical, 8)
    .padding(.horizontal, 12)
    .background(Color(.systemBackground))
    .cornerRadius(8)
  }
}


#Preview {
  StatisticsView()
}
