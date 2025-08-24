//
//  EditReflectionView.swift
//  Reflection
//
//  Created by 현유진 on 8/24/25.
//

import SwiftUI

// MARK: - 회고 편집 뷰
struct EditReflectionView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @StateObject private var editReflectionViewModel: EditReflectionViewModel = EditReflectionViewModel()
  @AppStorage("fontSize") private var fontSize = 16.0
  
  let reflection: Reflection
  
  var body: some View {
    NavigationStack {
      Form {
        BasicInfoSectionView(editReflectionViewModel: editReflectionViewModel)
        
        ContentSectionView(content: $editReflectionViewModel.content)
        
        TagsSectionView(editReflectionViewModel: editReflectionViewModel)
      }
      .navigationTitle("회고 편집")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("취소") {
            dismiss()
          }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("저장") {
            editReflectionViewModel.updateReflection(reflection, dismiss: dismiss)
          }
          .disabled(
            editReflectionViewModel.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            editReflectionViewModel.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
          )
        }
      }
    }
    .font(.system(size: fontSize))
    .onAppear {
      editReflectionViewModel.loadReflectionData(reflection)
    }
  }
}

// MARK: - 기본 정보 섹션 뷰
private struct BasicInfoSectionView: View {
  @ObservedObject private var editReflectionViewModel: EditReflectionViewModel
  
  fileprivate init(editReflectionViewModel: EditReflectionViewModel) {
    self.editReflectionViewModel = editReflectionViewModel
  }
  
  fileprivate var body: some View {
    Section("기본 정보") {
      TitleFieldView(title: $editReflectionViewModel.title)
      CategoryPickerView(selectedCategory: $editReflectionViewModel.selectedCategory)
    }
  }
}

// MARK: - 제목 필드 뷰
private struct TitleFieldView: View {
  @Binding var title: String
  
  fileprivate var body: some View {
    TextField("제목", text: $title)
      .font(.headline)
  }
}

// MARK: - 카테고리 선택 뷰
private struct CategoryPickerView: View {
  @Binding var selectedCategory: ReflectionCategory
  
  fileprivate var body: some View {
    Picker("카테고리", selection: $selectedCategory) {
      ForEach(ReflectionCategory.allCases, id: \.self) { category in
        HStack {
          Image(systemName: category.icon)
            .foregroundColor(Color(category.color))
          Text(category.rawValue)
        }
        .tag(category)
      }
    }
  }
}

// MARK - 컨텐츠 섹션 뷰
private struct ContentSectionView: View {
  @Binding var content: String
  
  fileprivate var body: some View {
    Section("내용") {
      TextField(
        "회고 내용을 작성해주세요",
        text: $content,
        axis: .vertical
      )
      .lineLimit(5...15)
    }
  }
}

private struct TagsSectionView: View {
  @ObservedObject private var editReflectionViewModel: EditReflectionViewModel
  
  fileprivate init(editReflectionViewModel: EditReflectionViewModel) {
    self.editReflectionViewModel = editReflectionViewModel
  }
  
  fileprivate var body: some View {
    Section("태그") {
      HStack {
        TextField("태그 입력", text: $editReflectionViewModel.tagInput)
        Button("추가") {
          editReflectionViewModel.addTag()
        }
        .disabled(
          editReflectionViewModel.tagInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        )
      }
    }
    
    if !editReflectionViewModel.tags.isEmpty {
      LazyVGrid(
        columns: [GridItem(.adaptive(minimum: 80))],
        alignment: .leading,
        spacing: 8
      ) {
        ForEach(Array(editReflectionViewModel.tags.enumerated()), id: \.offset) { index, tag in
          HStack {
            Text("#\(tag)")
            Button(
              action: {
                editReflectionViewModel.removeTag(at: index)
              },
              label: {
                Image(systemName: "xmark.circle.fill")
                  .foregroundColor(.secondary)
              }
            )
          }
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .background(Color.secondary.opacity(0.2))
          .cornerRadius(8)
        }
      }
    }
  }
}

// MARK: - 툴바 아이템 뷰
private struct ToolBarItemsView: View {
  fileprivate var body: some View {
    
  }
}

#Preview {
  EditReflectionView(
    reflection: Reflection(
      title: "SwiftUI 학습 회고",
      content: "오늘은 SwiftUI의 MVVM 패턴에 대해 학습했다. 처음에는 복잡해 보였지만, 코드를 분리하고 나니 훨씬 이해하기 쉬워졌다.",
      category: .learning,
      tags: ["iOS", "SwiftUI", "개발일지", "학습", "프로젝트", "회고", "앱개발", "코딩", "공부", "성장"]
    )
  )
}
