//
//  SummaryCardView.swift
//  Reflection
//
//  Created by 현유진 on 8/28/25.
//

import SwiftUI

// MARK: - 요약 카드 뷰
struct SummaryCardView: View {
  @StateObject private var summaryCardViewModel: SummaryCardViewModel = SummaryCardViewModel()
  
  let statistics: Statistics
  
  var body: some View {
    VStack(spacing: 16) {
      HStack {
        Text(summaryCardViewModel.title)
          .font(.headline)
        
        Spacer()
        
        if summaryCardViewModel.isLoading {
          ProgressView()
            .scaleEffect(0.8)
        }
      }
      
      HStack(spacing: 20) {
        ForEach(summaryCardViewModel.summaryItems, id: \.self) { item in
          StateItemView(
            title: item.title,
            value: item.value,
            icon: item.icon,
            color: item.color
          )
        }
      }
    }
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(12)
    .onAppear {
      summaryCardViewModel.updateData(from: statistics)
    }
    .onChange(of: statistics.totalCount) { oldValue, newValue in
      summaryCardViewModel.updateData(from: statistics)
    }
  }
}

private struct StateItemView: View {
  let title: String
  let value: String
  let icon: String
  let color: Color
  
  fileprivate var body: some View {
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

#Preview {
  let sampleStats = Statistics(
    totalCount: 42,
    categoryStats: [],
    weeklyStats: [DateStatistics(date: Date(), count: 3)],
    monthlyStats: [DateStatistics(date: Date(), count: 12)],
    topTags: [],
    recentReflections: []
  )
  
  return SummaryCardView(statistics: sampleStats)
    .padding()
}
