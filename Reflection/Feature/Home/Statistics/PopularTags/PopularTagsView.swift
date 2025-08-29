//
//  PopularTagsView.swift
//  Reflection
//
//  Created by 현유진 on 8/28/25.
//

import SwiftUI


// MARK: - 인기 태그
struct PopularTagsView: View {
  let statistics: Statistics
  
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



#Preview {
//    PopularTagsView()
}
