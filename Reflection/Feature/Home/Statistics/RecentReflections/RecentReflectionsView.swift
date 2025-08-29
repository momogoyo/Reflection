//
//  RecentReflectionsView.swift
//  Reflection
//
//  Created by 현유진 on 8/28/25.
//

import SwiftUI

// MARK: - 최근 회고
struct RecentReflectionsView: View {
  let statistics: Statistics
  
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
//    RecentReflectionsView()
}
