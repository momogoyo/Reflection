//
//  AddReflectionViewModel.swift
//  Reflection
//
//  Created by 현유진 on 8/23/25.
//

import Foundation
import SwiftData
import SwiftUI

class AddReflectionViewModel: ObservableObject {
  @Published var title: String
  @Published var content: String
  @Published var selectedCategory: ReflectionCategory
  @Published var tags: [String]
  @Published var tagInput: String
  
  private var modelContext: ModelContext?
  
  var isTagInputEmpty: Bool {
    let tag = self.tagInput
    return tag.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
  }
  
  init(
    title: String = "",
    content: String = "",
    selectedCategory: ReflectionCategory = ReflectionCategory.personal,
    tags: [String] = [],
    tagInput: String = "",
    modelContext: ModelContext? = nil
  ) {
    self.title = title
    self.content = content
    self.selectedCategory = selectedCategory
    self.tags = tags
    self.tagInput = tagInput
    self.modelContext = modelContext
  }
}

// MARK: - Setup Methods
extension AddReflectionViewModel {
  func setModelContext(_ modelContext: ModelContext) {
    self.modelContext = modelContext
  }
}

// MARK: - Action Methods
extension AddReflectionViewModel {
  func addTag() {
    let trimmedTag = tagInput.trimmingCharacters(in: .whitespacesAndNewlines)
    
    if trimmedTag.isEmpty && !tags.contains(where: { $0 == trimmedTag }) {
      tags.append(trimmedTag)
      tagInput = ""
    }
  }
  
  func removeTagAt(_ index: Int) {
    guard index >= 0 && index < tags.count else { return }
    
    tags.remove(at: index)
  }
  
  func saveReflection(dismiss: DismissAction) {
    let reflection = Reflection(
      title: title.trimmingCharacters(in: .whitespacesAndNewlines),
      content: content.trimmingCharacters(in: .whitespacesAndNewlines),
      category: selectedCategory,
      tags: tags.map { $0 }
    )
    
    modelContext?.insert(reflection)
    dismiss()
  }
}
