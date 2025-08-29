//
//  AddReflectionViewModel.swift
//  Reflection
//
//  Created by 현유진 on 8/23/25.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
class AddReflectionViewModel: ObservableObject {
  @Published var title: String
  @Published var content: String
  @Published var selectedCategory: ReflectionCategory
  @Published var tags: [String]
  @Published var tagInput: String
  
  private var modelContext: ModelContext?
  
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

// MARK: - Computed Property
extension AddReflectionViewModel {
  var canSave: Bool {
    !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
    !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
  
  var isTagInputEmpty: Bool {
    tagInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
  
  var canAddTag: Bool {
    !isTagInputEmpty
  }
  
  var cleanTagInput: String {
    tagInput.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  var cleanTitle: String {
    title.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  var cleanContent: String {
    content.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}

// MARK: - Action Methods
extension AddReflectionViewModel {
  func setModelContext(_ context: ModelContext) {
    self.modelContext = context
  }
  
  func addTag() {
    let trimmedTag = tagInput.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmedTag.isEmpty && !tags.contains(trimmedTag) else { return }
    
    withAnimation(.easeInOut(duration: 0.2)) {
      tags.append(trimmedTag)
    }
    tagInput = ""
    print("태그 추가됨: '\(trimmedTag)', 현재 태그: \(tags)")
  }
  
  func removeTag(at index: Int) {
    guard index >= 0 && index < tags.count else {
      print("잘못된 인덱스: \(index), 배열 크기: \(tags.count)")
      return
    }
    
    let removingTag = tags[index]
    _ = withAnimation(.easeInOut(duration: 0.2)) {
      tags.remove(at: index)
    }
    print("태그 삭제됨: '\(removingTag)', 현재 태그: \(tags)")
  }
  
  func removeTag(_ tag: String) {
    withAnimation(.easeInOut(duration: 0.2)) {
      tags.removeAll { $0 == tag }
    }
    print("태그 삭제됨: '\(tag)', 현재 태그: \(tags)")
  }
  
  func saveReflection(dismiss: DismissAction) {
    guard let modelContext = modelContext, canSave else { return }
    
    let reflection = Reflection(
      title: cleanTitle,
      content: cleanContent,
      category: selectedCategory,
      tags: tags
    )
    
    modelContext.insert(reflection)
    
    do {
      try modelContext.save()
      print("회고 저장 완료")
      dismiss()
    } catch {
      print("저장 실패: \(error)")
    }
  }
  
  func resetForm() {
    title = ""
    content = ""
    selectedCategory = .personal
    tags = []
    tagInput = ""
  }
}
