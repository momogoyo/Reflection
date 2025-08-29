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
        BasicInfoSection(
          title: $editReflectionViewModel.title,
          selectedCategory: $editReflectionViewModel.selectedCategory
        )
        
        ContentSection(content: $editReflectionViewModel.content)
        
        TagsSection(
          tags: $editReflectionViewModel.tags,
          tagInput: $editReflectionViewModel.tagInput,
          onAddTag: editReflectionViewModel.addTag,
          onRemoveTag: editReflectionViewModel.removeTag,
          canAddTag: editReflectionViewModel.canAddTag
        )
      }
      .navigationTitle("회고 편집")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        CustomNavigationBar.standard(
          onCancel: {
            dismiss()
          },
          onSave: {
            editReflectionViewModel.updateReflection(reflection, dismiss: dismiss)
          },
          isSaveDisabled: (!editReflectionViewModel.canSave)
        )
      }
    }
    .font(.system(size: fontSize))
    .onAppear {
      editReflectionViewModel.setModelContext(modelContext)
      editReflectionViewModel.loadReflectionData(reflection)
    }
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
