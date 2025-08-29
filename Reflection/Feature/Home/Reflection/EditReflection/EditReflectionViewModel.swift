//
//  EditReflectionViewModel.swift
//  Reflection
//
//  Created by 현유진 on 8/24/25.
//

import Foundation
import SwiftData
import SwiftUI

//class EditReflectionViewModel: ObservableObject {
//  @Published var title: String
//  @Published var content: String
//  @Published var selectedCategory: ReflectionCategory
//  @Published var tags: [String]
//  @Published var tagInput: String
//  
//  private var modelContext: ModelContext?
//  
//  var isTagInputEmpty: Bool {
//    let tag = self.tagInput
//    return tag.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
//  }
//  
//  init(
//    title: String  = "",
//    content: String = "",
//    selectedCategory: ReflectionCategory = ReflectionCategory.personal,
//    tags: [String] = [],
//    tagInput: String = "",
//    modelContext: ModelContext? = nil
//  )
//  {
//    self.title = title
//    self.content = content
//    self.selectedCategory = selectedCategory
//    self.tags = tags
//    self.tagInput = tagInput
//    self.modelContext = modelContext
//  }
//}
//
//// MARK: - Setup Methods
//extension EditReflectionViewModel {
//  func setModelContext(_ modelContext: ModelContext) {
//    self.modelContext = modelContext
//  }
//}
//
//// MARK: - Action Methods
//extension EditReflectionViewModel {
//  func loadReflectionData(_ reflection: Reflection) {
//    title = reflection.title
//    content = reflection.content
//    selectedCategory = reflection.category
//    tags = reflection.tags
//  }
//  
//  func addTag() {
//    let trimmedTag = tagInput.trimmingCharacters(in: .whitespacesAndNewlines)
//    
//    if !trimmedTag.isEmpty && !tags.contains(where: { $0 == trimmedTag }) {
//      tags.append(trimmedTag)
//      tagInput = ""
//    }
//  }
//  
//  func removeTagAt(_ index: Int) {
//    guard index >= 0 && index < self.tags.count else { return }
//    
//    tags.remove(at: index)
//  }
//  
//  func updateReflection(
//    _ reflection: Reflection,
//    dismiss: DismissAction
//  ) {
//    reflection.updateContent(
//      title: title.trimmingCharacters(in: .whitespacesAndNewlines),
//      content: content.trimmingCharacters(in: .whitespacesAndNewlines),
//      category: selectedCategory,
//      tags: tags
//    )
//    
//    dismiss()
//  }
//}


@MainActor
class EditReflectionViewModel: ObservableObject {
    @Published var title = ""
    @Published var content = ""
    @Published var selectedCategory = ReflectionCategory.personal
    @Published var tags: [String] = []
    @Published var tagInput = ""
    
    private var modelContext: ModelContext?
    
    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isTagInputEmpty: Bool {
        tagInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var canAddTag: Bool {
        let trimmed = tagInput.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && !tags.contains(trimmed)
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
    
    var hasTags: Bool {
        !tags.isEmpty
    }
    
    var tagCount: Int {
        tags.count
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func loadReflectionData(_ reflection: Reflection) {
        title = reflection.title
        content = reflection.content
        selectedCategory = reflection.category
        tags = reflection.tags
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
        withAnimation(.easeInOut(duration: 0.2)) {
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
    
    func updateReflection(_ reflection: Reflection, dismiss: DismissAction) {
        guard canSave else { return }
        
        reflection.updateContent(
            title: cleanTitle,
            content: cleanContent,
            category: selectedCategory,
            tags: tags
        )
        
        do {
            try modelContext?.save()
            print("회고 업데이트 완료")
            dismiss()
        } catch {
            print("업데이트 실패: \(error)")
        }
    }
}
