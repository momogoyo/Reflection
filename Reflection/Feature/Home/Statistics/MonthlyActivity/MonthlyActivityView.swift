//
//  MonthlyActivityView.swift
//  Reflection
//
//  Created by 현유진 on 8/28/25.
//

import SwiftUI

// MARK: - 월별 활동 차트
struct MonthlyActivityView: View {
  let statistics: Statistics
  
  //  private var monthlyData: [(date: Date, count: Int)] {
  //    statistics.monthlyStats
  //      .sorted { $0.key < $1.key }
  //      .map { (date: $0.key, count: $0.value) }
  //  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("월별 활동 (최근 6개월)")
        .font(.headline)
      
      //      if !monthlyData.isEmpty {
      //        Chart(monthlyData, id: \.date) { item in
      //          LineMark(
      //            x: .value("월", item.date, unit: .month),
      //            y: .value("회고 수", item.count)
      //          )
      //          .foregroundStyle(.green)
      //          .lineStyle(StrokeStyle(lineWidth: 3))
      //          .symbol(Circle().strokeBorder(lineWidth: 2))
      //          .symbolSize(50)
      //
      //          AreaMark(
      //            x: .value("월", item.date, unit: .month),
      //            y: .value("회고 수", item.count)
      //          )
      //          .foregroundStyle(.green.opacity(0.2))
      //        }
      //        .frame(height: 180)
      //        .chartXAxis {
      //          AxisMarks(values: .stride(by: .month)) { value in
      //            if let date = value.as(Date.self) {
      //              AxisValueLabel {
      //                Text(date, format: .dateTime.month(.abbreviated))
      //                  .font(.caption)
      //              }
      //            }
      //          }
      //        }
      //        .chartYAxis {
      //          AxisMarks { value in
      //            AxisValueLabel {
      //              if let intValue = value.as(Int.self) {
      //                Text("\(intValue)")
      //                  .font(.caption)
      //              }
      //            }
      //          }
      //        }
      //      } else {
      Text("데이터가 없습니다")
        .foregroundColor(.secondary)
        .frame(height: 100)
        .frame(maxWidth: .infinity)
      //      }
    }
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(12)
  }
}

#Preview {
//    MonthlyActivityView()
}
