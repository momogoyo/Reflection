//
//  ReflectionDetailViewModel.swift
//  Reflection
//
//  Created by 현유진 on 8/22/25.
//

import Foundation
import SwiftData
import SwiftUI

class ReflectionDetailViewModel: ObservableObject {
  @Published var showingEditView: Bool
  @Published var showingDeleteAlert: Bool
  @Published var isDeleting: Bool
  
  private var modelContext: ModelContext?
  
  var canDelete: Bool {
    !isDeleting
  }
  
  init(
    showingEditView: Bool = false,
    showingDeleteAlert: Bool = false,
    isDeleting: Bool = false,
    modelContext: ModelContext? = nil
  ) {
    self.showingEditView = showingEditView
    self.showingDeleteAlert = showingDeleteAlert
    self.isDeleting = isDeleting
    self.modelContext = modelContext
  }
}

// MARK: - Setup Methods
extension ReflectionDetailViewModel {
  func setModelContext(_ context: ModelContext) {
    self.modelContext = context
  }
}

// MARK: - Action Methods
extension ReflectionDetailViewModel {
  func setEditViewShown(_ shown: Bool) {
    self.showingEditView = shown
  }
  
  func setDeleteAlertShown(_ shown: Bool) {
    self.showingDeleteAlert = shown
  }
  
  func deleteReflection(
    _ reflection: Reflection,
    dismiss: DismissAction
  ) {
    guard let modelContext = modelContext else { return }
    
    isDeleting = true
    
    withAnimation(.easeInOut(duration: 0.3)) {
      modelContext.delete(reflection)
      
      do {
        try modelContext.save()
        
        // 삭제 성공 후 화면 닫기
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
          dismiss() // 화면 닫기
        }
        
      } catch {
        print("회고 삭제 실패: \(error.localizedDescription)")
        isDeleting = false
      }
    }
  }
}
