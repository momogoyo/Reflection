//
//  ReflectionDetailView.swift
//  Reflection
//
//  Created by 현유진 on 8/22/25.
//

import Foundation
import SwiftUI
import SwiftData

// MARK: - 회고 상세 뷰
struct ReflectionDetailView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @StateObject private var reflectionDetailViewModel: ReflectionDetailViewModel = ReflectionDetailViewModel()
  @AppStorage("fontSize") private var fontSize = 16.0
  
  let reflection: Reflection
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        ReflectionHeaderView(reflection: reflection)
        Divider()
        
        ReflectionContentView(reflection: reflection)
        ReflectionTagsView(reflection: reflection)
      }
      .padding()
    }
    .navigationTitle("")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        Button("편집") {
          reflectionDetailViewModel.showEditView()
        }
        
        Button("삭제") {
          reflectionDetailViewModel.showDeleteAlert()
        }
        .foregroundColor(.red)
      }
    }
    .sheet(isPresented: $reflectionDetailViewModel.showingEditView) {
      EditReflectionView(reflection: reflection)
    }
    .alert("회고 삭제", isPresented: $reflectionDetailViewModel.showingDeleteAlert) {
      Button("취소", role: .cancel) { }
      Button("삭제", role: .destructive) {
        reflectionDetailViewModel.deleteReflection(reflection, dismiss: dismiss)
      }
    } message: {
      Text("이 회고를 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.")
    }
    .font(.system(size: fontSize))
    .onAppear {
      reflectionDetailViewModel.setModelContext(modelContext)
    }
  }
}

private struct ReflectionHeaderView: View {
  let reflection: Reflection
  
  fileprivate var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Image(systemName: reflection.category.icon)
          .foregroundColor(Color(reflection.category.color))
          .font(.title2)
        
        Text(reflection.category.rawValue)
          .font(.headline)
          .foregroundColor(Color(reflection.category.color))
        
        Spacer()
      }
      
      Text(reflection.title)
        .font(.title.weight(.bold))
        .fixedSize(horizontal: false, vertical: true)
      
      HStack {
        Text("작성일: \(reflection.createdAt.formatted)")
          .font(.caption)
          .foregroundColor(.secondary)
        
        if reflection.createdAt != reflection.updatedAt {
          Text("• 수정일: \(reflection.updatedAt.formatted)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }
    }
  }
  
  private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter
  }
}

private struct ReflectionContentView: View {
  let reflection: Reflection
  
  fileprivate var body: some View {
    Text(reflection.content)
      .font(.body)
      .fixedSize(horizontal: false, vertical: true)
  }
}

private struct ReflectionTagsView: View {
  let reflection: Reflection
  
  fileprivate var body: some View {
    if !reflection.tags.isEmpty {
      VStack(alignment: .leading, spacing: 8) {
        Text("태그")
          .font(.headline)
        
        LazyVGrid(columns: [
          GridItem(.adaptive(minimum: 80))
        ], alignment: .leading, spacing: 8) {
          ForEach(reflection.tags, id: \.self) { tag in
            Text("#\(tag)")
              .font(.subheadline)
              .padding(.horizontal, 12)
              .padding(.vertical, 6)
              .background(Color.accentColor.opacity(0.2))
              .cornerRadius(12)
          }
        }
      }
    }
  }
}

#Preview {
  NavigationView {
    ReflectionDetailView(
      reflection: Reflection(
        title: "SwiftUI 학습 회고",
        content: "오늘은 SwiftUI의 MVVM 패턴에 대해 학습했다.",
        category: .learning,
        tags: ["iOS", "SwiftUI", "학습"]
      )
    )
  }
}
