//
//  EditReflectionViewModel.swift
//  Reflection
//
//  Created by 현유진 on 8/24/25.
//

import Foundation
import SwiftData
import SwiftUI

class EditReflectionViewModel: ObservableObject {
  @Published var title: String
  @Published var content: String
  @Published var selectedCategory: ReflectionCategory
  @Published var tags: [String]
  @Published var tagInput: String
  
  private var modelContext: ModelContext?
  
  init(
    title: String  = "",
    content: String = "",
    selectedCategory: ReflectionCategory = ReflectionCategory.personal,
    tags: [String] = [],
    tagInput: String = "",
    modelContext: ModelContext? = nil
  )
  {
    self.title = title
    self.content = content
    self.selectedCategory = selectedCategory
    self.tags = tags
    self.tagInput = tagInput
    self.modelContext = modelContext
  }
}

// MARK: - Setup Methods
extension EditReflectionViewModel {
  func setModelContext(_ modelContext: ModelContext) {
    self.modelContext = modelContext
  }
}

// MARK: - Action Methods
extension EditReflectionViewModel {
  func loadReflectionData(_ reflection: Reflection) {
    title = reflection.title
    content = reflection.content
    selectedCategory = reflection.category
    tags = reflection.tags
  }
  
  func addTag() {
    let trimmedTag = tagInput.trimmingCharacters(in: .whitespacesAndNewlines)
    if !trimmedTag.isEmpty && !tags.contains(trimmedTag) {
      tags.append(trimmedTag)
      tagInput = ""
    }
  }
  
  func removeTag(at index: Int) {
    tags.remove(at: index)
  }
  
  func updateReflection(
    _ reflection: Reflection,
    dismiss: DismissAction
  ) {
    reflection.updateContent(
      title: title.trimmingCharacters(in: .whitespacesAndNewlines),
      content: content.trimmingCharacters(in: .whitespacesAndNewlines),
      category: selectedCategory,
      tags: tags
    )
    
    dismiss()
  }
}
