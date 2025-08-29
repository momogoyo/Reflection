//
//  ReflectionDetailViewModel.swift
//  Reflection
//
//  Created by 현유진 on 8/22/25.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
class ReflectionDetailViewModel: ObservableObject {
  @Published var showingEditView: Bool
  @Published var showingDeleteAlert: Bool
  
  private var modelContext: ModelContext?
  
  init(
    showingEditView: Bool = false,
    showingDeleteAlert: Bool = false
  ) {
    self.showingEditView = showingEditView
    self.showingDeleteAlert = showingDeleteAlert
  }
}

// MARK: - Action Methods
extension ReflectionDetailViewModel {
  func setModelContext(_ context: ModelContext) {
    self.modelContext = context
  }
  
  func showEditView() {
    showingEditView = true
  }
  
  func showDeleteAlert() {
    showingDeleteAlert = true
  }
  
  func deleteReflection(_ reflection: Reflection, dismiss: DismissAction) {
    guard let modelContext = modelContext else { return }
    
    modelContext.delete(reflection)
    
    do {
      try modelContext.save()
      dismiss()
    } catch {
      print("삭제 실패: \(error)")
    }
  }
}
