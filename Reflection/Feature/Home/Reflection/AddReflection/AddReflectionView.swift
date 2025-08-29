//
//  AddReflectionView.swift
//  Reflection
//
//  Created by 현유진 on 8/22/25.
//

import SwiftUI

// MARK: - 회고 추가 뷰
struct AddReflectionView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @StateObject private var addReflectionViewModel: AddReflectionViewModel = AddReflectionViewModel()
  @AppStorage("fontSize") private var fontSize = 16.0
  
  var body: some View {
    NavigationStack {
      Form {
        BasicInfoSection(
          title: $addReflectionViewModel.title,
          selectedCategory: $addReflectionViewModel.selectedCategory
        )
        
        ContentSection(content: $addReflectionViewModel.content)
        
        TagsSection(
          tags: $addReflectionViewModel.tags,
          tagInput: $addReflectionViewModel.tagInput,
          onAddTag: addReflectionViewModel.addTag,
          onRemoveTag: addReflectionViewModel.removeTag,
          canAddTag: addReflectionViewModel.canAddTag
        )
      }
      .navigationTitle("새 회고")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        CustomNavigationBar.standard(
          onCancel: {
            dismiss()
          },
          onSave: {
            addReflectionViewModel.saveReflection(dismiss: dismiss)
          },
          isSaveDisabled: (!addReflectionViewModel.canSave)
        )
      }
    }
    .font(.system(size: fontSize))
    .onAppear {
      addReflectionViewModel.setModelContext(modelContext)
    }
  }
}

#Preview {
  AddReflectionView()
}
