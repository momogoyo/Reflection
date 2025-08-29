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
  @StateObject private var statisticsViewModel: StatisticsViewModel = StatisticsViewModel()
  
  var body: some View {
    NavigationStack {
      if statisticsViewModel.isLoading {
        ProgressView("통계 계산 중...")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
        ScrollView {
          LazyVStack(spacing: 20) {
            // 전체 요약
            SummaryCardView(statistics: statisticsViewModel.statistics)
            
            // 카테고리별 통계
            CategoryStatsView(statistics: statisticsViewModel.statistics)
            
            // 주별 활동 차트
            WeeklyActivityView(statistics: statisticsViewModel.statistics)
            
            // 월별 활동 차트
            MonthlyActivityView(statistics: statisticsViewModel.statistics)
            
            // 인기 태그
            PopularTagsView(statistics: statisticsViewModel.statistics)
            
            // 최근 회고
            RecentReflectionsView(statistics: statisticsViewModel.statistics)
          }
          .padding()
        }
      }
    }
    .navigationTitle("통계")
    .font(.system(size: fontSize))
    .onAppear {
      statisticsViewModel.updateStatistics(from: reflections)
    }
    .onChange(of: reflections.count) { oldValue, newValue in
      statisticsViewModel.updateStatistics(from: reflections)
    }
  }
}

#Preview {
  StatisticsView()
}

