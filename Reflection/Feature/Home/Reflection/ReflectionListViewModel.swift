//
//  ReflectionListViewModel.swift
//  Reflection
//
//  Created by 현유진 on 8/22/25.
//

import Foundation
import SwiftData

class ReflectionListViewModel: ObservableObject {
  @Published var showingAddReflection: Bool
  @Published var selectedCategory: ReflectionCategory?
  @Published var searchText: String
  
  private var modelContext: ModelContext?
  
  init(
    showingAddReflection: Bool = false,
    selectedCategory: ReflectionCategory? = nil,
    searchText: String = "",
    modelContext: ModelContext? = nil
  ) {
    self.showingAddReflection = showingAddReflection
    self.selectedCategory = selectedCategory
    self.searchText = searchText
    self.modelContext = modelContext
  }
  
  // 회고 목록 필터링
  func filteredReflections(from reflections: [Reflection]) -> [Reflection] {
    var result = reflections
    
    // 카테고리 필터링
    if let category = selectedCategory {
      result = result.filter { $0.category == category }
    }
    
    // 검색 필터링
    if !searchText.isEmpty {
      result = result.filter { reflection in
        reflection.title.contains(searchText) ||
        reflection.content.contains(searchText) ||
        reflection.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
      }
    }
    
    return result
  }
}

// MARK: - ModelContext 설정
extension ReflectionListViewModel {
  func setModelContext(_ context: ModelContext) {
    self.modelContext = context
  }
}

// MARK: - Actions 관련 메소드
extension ReflectionListViewModel {
  // 카테고리 필터 선택
  func selectedCategory(_ category: ReflectionCategory) {
    self.selectedCategory = category
  }
  
  // 회고 삭제
  func deleteReflections(at offsets: IndexSet, from reflections: [Reflection]) {
    guard let modelContext = modelContext else { return }
    
    for index in offsets {
      modelContext.delete(reflections[index])
    }
    
    do {
      // 자동 저장
      try modelContext.save()
    } catch {
      print("회고 삭제 중 오류 발생: \(error)")
      
    }
  }
}
