//
//  CategoryStatsView.swift
//  Reflection
//
//  Created by 현유진 on 8/28/25.
//

import SwiftUI

// MARK: - 카테고리별 통계
struct CategoryStatsView: View {
  @StateObject private var categoryStatsViewModel: CategoryStatsViewModel = CategoryStatsViewModel()
  
  let statistics: Statistics
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Text(categoryStatsViewModel.title)
          .font(.headline)
        
        Spacer()
        
        if categoryStatsViewModel.isLoading {
          ProgressView()
            .scaleEffect(0.8)
        }
      }
      
      if categoryStatsViewModel.isEmpty {
        Text("카테고리 데이터가 없습니다.")
          .foregroundColor(.secondary)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .padding()
      } else {
        ForEach(categoryStatsViewModel.categoryStats, id: \.self) { categoryStat in
          CategoryRowView(
            categoryStatistic: categoryStat,
            totalCount: categoryStatsViewModel.totalCount
          )
        }
      }
    }
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(12)
    .onAppear {
      categoryStatsViewModel.updateData(from: statistics)
    }
    .onChange(of: statistics.totalCount) { oldValue, newValue in
      categoryStatsViewModel.updateData(from: statistics)
    }
  }
}

// MARK: - 카테고리 행
struct CategoryRowView: View {
  let categoryStatistic: CategoryStatistics
  let totalCount: Int
  
  var body: some View {
    VStack(spacing: 4) {
      HStack {
        Image(systemName: categoryStatistic.category.icon)
          .foregroundColor(Color(categoryStatistic.category.color))
          .frame(width: 20)
        
        Text(categoryStatistic.category.rawValue)
          .font(.subheadline)
        
        Spacer()
        
        Text("\(categoryStatistic.count)개")
          .font(.subheadline.weight(.medium))
          .foregroundColor(.secondary)
      }
      
      ProgressView(value: categoryStatistic.percentage(of: totalCount), total: 1.0)
        .progressViewStyle(LinearProgressViewStyle(tint: Color(categoryStatistic.category.color)))
        .scaleEffect(y: 0.8)
    }
    .padding(.vertical, 4)
  }
}


#Preview {
  let sampleStats = Statistics(
    totalCount: 32,
    categoryStats: [
      CategoryStatistics(category: .personal, count: 10),
      CategoryStatistics(category: .teamwork, count: 6),
      CategoryStatistics(category: .learning, count: 4),
      CategoryStatistics(category: .emotion, count: 12),
    ],
    weeklyStats: [],
    monthlyStats: [],
    topTags: [],
    recentReflections: []
  )
  
  CategoryStatsView(statistics: sampleStats)
    .padding()
}
