//
//  WeeklyActivityView.swift
//  Reflection
//
//  Created by 현유진 on 8/28/25.
//

import SwiftUI
import Charts

// MARK: - 주별 활동 차트
struct WeeklyActivityView: View {
  @StateObject private var weeklyActivityViewModel: WeeklyActivityViewModel = WeeklyActivityViewModel()
  
  let statistics: Statistics
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      TitleView(weeklyActivityViewModel: weeklyActivityViewModel)
      
      if !weeklyActivityViewModel.isEmpty {
        ChartView(weeklyData: weeklyActivityViewModel.weeklyData)
      } else {
        NoDataView()
      }
    }
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(12)
    .onAppear {
      weeklyActivityViewModel.updateData(from: statistics)
    }
  }
}

// MARK: - 주별 활동 타이틀 뷰
private struct TitleView: View {
  @ObservedObject private var weeklyActivityViewModel: WeeklyActivityViewModel
  
  fileprivate init(weeklyActivityViewModel: WeeklyActivityViewModel) {
    self.weeklyActivityViewModel = weeklyActivityViewModel
  }
  
  fileprivate var body: some View {
    HStack {
      Text(weeklyActivityViewModel.title)
        .font(.headline)
      
      Spacer()
      
      if weeklyActivityViewModel.isLoading {
        ProgressView()
          .scaleEffect(0.8)
      }
      
    }
  }
}

// MARK: - 차트 뷰
private struct ChartView: View {
  let weeklyData: [DateStatistics]
  
  fileprivate var body: some View {
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
  }
}

// MARK: - 데이터가 없을 경우 표시해줄 뷰
private struct NoDataView: View {
  fileprivate var body: some View {
    Text("데이터가 없습니다.")
      .foregroundColor(.secondary)
      .frame(height: 100)
      .frame(maxWidth: .infinity)
  }
}

#Preview {
  let sampleStats = Statistics(
    totalCount: 13,
    categoryStats: [],
    weeklyStats: [
      DateStatistics(
        date: Calendar.current.date(byAdding: .weekOfYear, value: -7, to: Date())!,
        count: 1
      ),
      DateStatistics(
        date: Calendar.current.date(byAdding: .weekOfYear, value: -6, to: Date())!,
        count: 2
      ),
      DateStatistics(
        date: Calendar.current.date(byAdding: .weekOfYear, value: -5, to: Date())!,
        count: 4
      ),
      DateStatistics(
        date: Calendar.current.date(byAdding: .weekOfYear, value: -4, to: Date())!,
        count: 2
      ),
      DateStatistics(
        date: Calendar.current.date(byAdding: .weekOfYear, value: -3, to: Date())!,
        count: 4
      ),
      DateStatistics(
        date: Calendar.current.date(byAdding: .weekOfYear, value: -2, to: Date())!,
        count: 1
      ),
      DateStatistics(
        date: Date(),
        count: 0
      )
    ],
    monthlyStats: [],
    topTags: [],
    recentReflections: []
  )
  
  WeeklyActivityView(statistics: sampleStats)
    .padding()
}
