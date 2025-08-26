//
//  ReflectionDetailView.swift
//  Reflection
//
//  Created by 현유진 on 8/22/25.
//

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
    GeometryReader{ geometry in
      ScrollView(.vertical) {
        VStack(
          alignment: .leading,
          spacing: 16
        ) {
          HeaderSectionView(reflection: reflection)
          
          Divider()
          
          ContentSectionView(reflection: reflection)
        }
        .padding()
      }
    }
    .navigationTitle("")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        Button("편집") {
          reflectionDetailViewModel.setEditViewShown(true)
        }
        .disabled(reflectionDetailViewModel.isDeleting)
        
        Button("삭제") {
          reflectionDetailViewModel.setDeleteAlertShown(true)
        }
        .foregroundColor(.red)
        .disabled(!reflectionDetailViewModel.canDelete)
      }
    }
    .sheet(isPresented: $reflectionDetailViewModel.showingEditView) {
      EditReflectionView(reflection: reflection)
    }
    .alert(
      "회고 삭제",
      isPresented: $reflectionDetailViewModel.showingDeleteAlert
    ) {
      Button("취소", role: .cancel) {
        reflectionDetailViewModel.setDeleteAlertShown(false)
      }
      Button("삭제", role: .destructive) {
        reflectionDetailViewModel.deleteReflection(reflection, dismiss: dismiss)
      }
    } message: {
      Text("이 회고를 삭제하시겠습니까?")
    }
    .font(.system(size: fontSize))
    .onAppear {
      reflectionDetailViewModel.setModelContext(modelContext)
    }
    .overlay {
      if reflectionDetailViewModel.isDeleting {
        ProgressView("삭제 중...")
          .padding()
          .background(.regularMaterial)
          .cornerRadius(12)
      }
    }
  }
}

// MARK: - 회고 상세 헤더 뷰
private struct HeaderSectionView: View {
  let reflection: Reflection
  
  fileprivate var body: some View {
    VStack(
      alignment: .leading,
      spacing: 8
    ) {
      HStack {
        CategoryBadgeView(category: reflection.category)
        Spacer()
        DateInfoView(reflection: reflection)
      }
      
      Spacer()
        .frame(height: 4)
      
      TitleView(reflection: reflection)
      
      Spacer()
        .frame(height: 1)
      
      if !reflection.tags.isEmpty {
        TagsScrollView(tags: reflection.tags)
      }
    }
  }
}

// MARK: - 제목 뷰
private struct TitleView: View {
  let reflection: Reflection
  
  fileprivate var body: some View {
    Text(reflection.title)
      .font(.system(.title, weight: .bold))
      .fixedSize(
        horizontal: false,
        vertical: true
      )
  }
}

private struct CategoryBadgeView: View {
  let category: ReflectionCategory
  
  fileprivate var body: some View {
    HStack {
      Image(systemName: category.icon)
        .foregroundColor(Color(category.color))
        .font(.title2)
      
      Text(category.rawValue)
        .font(.headline)
        .foregroundColor(Color(category.color))
    }
  }
}

// MARK: - 날짜 표시 뷰
private struct DateInfoView: View {
  let reflection: Reflection
  
  fileprivate var body: some View {
    VStack(spacing: 4) {
      HStack(spacing: 4) {
        Image(systemName: "plus.circle.fill")
          .foregroundColor(.green)
          .font(.caption2)
        Text("생성 \(reflection.createdAt, formatter: reflection.createdAt.dateFormatter)")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      
      if reflection.createdAt != reflection.updatedAt {
        HStack(spacing: 4) {
          Image(systemName: "arrow.clockwise.circle.fill")
            .foregroundColor(.blue)
            .font(.caption2)
          Text("수정 \(reflection.updatedAt, formatter: reflection.updatedAt.dateFormatter)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }
    }
  }
}

// MARK: - 태그 영역 뷰
private struct TagsScrollView: View {
  let tags: [String]
  
  fileprivate var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Spacer()
        .frame(height: 2)
      
      ScrollView(
        .horizontal,
        showsIndicators: false
      ) {
        HStack(spacing: 8) {
          ForEach(tags, id: \.self) { tag in
            Text("#\(tag)")
              .font(.caption)
              .padding(.horizontal, 8)
              .padding(.vertical, 4)
              .background(Color.secondary.opacity(0.2))
              .cornerRadius(8)
          }
        }
      }
    }
  }
}

// MARK: - 회고 상세 본문 뷰
private struct ContentSectionView: View {
  let reflection: Reflection
  
  fileprivate var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(reflection.content)
        .font(.body)
        .fixedSize(horizontal: false, vertical: true)
      
      Spacer()
    }
  }
}

#Preview {
  ReflectionDetailView(
    reflection: Reflection(
      title: "SwiftUI 학습 회고",
      content: "오늘은 SwiftUI의 MVVM 패턴에 대해 학습했다. 처음에는 복잡해 보였지만, 코드를 분리하고 나니 훨씬 이해하기 쉬워졌다.",
      category: .learning,
      tags: [ "iOS", "SwiftUI", "개발일지", "학습", "프로젝트", "회고", "앱개발", "코딩", "공부", "성장"]
    )
  )
}
