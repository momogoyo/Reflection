//
//  CustomNavigationBar.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

import SwiftUI

// MARK: - 네비게이션 툴바
struct CustomNavigationBar: ToolbarContent {
  let cancelAction: (() -> Void)?
  let saveAction: (() -> Void)?
  let addAction: (() -> Void)?
  let isSaveDisabled: Bool
  let cancelTitle: String
  let saveTitle: String
  
  init(
    cancelAction: (() -> Void)? = nil,
    saveAction: (() -> Void)? = nil,
    addAction: (() -> Void)? = nil,
    isSaveDisabled: Bool = false,
    cancelTitle: String = "취소",
    saveTitle: String = "저장"
  ) {
    self.cancelAction = cancelAction
    self.saveAction = saveAction
    self.addAction = addAction
    self.isSaveDisabled = isSaveDisabled
    self.cancelTitle = cancelTitle
    self.saveTitle = saveTitle
  }
  
  var body: some ToolbarContent {
    if let cancelAction {
      ToolbarItem(placement: .navigationBarLeading) {
        Button(cancelTitle) {
          cancelAction()
        }
      }
    }
    
    if let addAction {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: addAction) {
          Image(systemName: "plus")
        }
        .accessibilityLabel(Text("항목 추가"))
      }
    }
    
    if let saveAction {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(saveTitle) { saveAction() }
          .disabled(isSaveDisabled)
      }
    }
    
  }
}

// MARK: - 편의 초기화
extension CustomNavigationBar {
  static func cancelOnly(
    cancelTitle: String = "취소",
    dismiss: DismissAction
  ) -> some ToolbarContent {
    CustomNavigationBar(
      cancelAction: {
        dismiss()
      },
      saveAction: nil,
      addAction: nil,
      isSaveDisabled: true,
      cancelTitle: cancelTitle,
      saveTitle: ""
    )
  }
  
  static func addOnly(
    onAdd: @escaping () -> Void,
  ) -> some ToolbarContent {
    CustomNavigationBar(
      cancelAction: nil,
      saveAction: nil,
      addAction: onAdd,
      isSaveDisabled: true
    )
  }
  
  static func standard(
    onCancel: @escaping () -> Void,
    onSave: @escaping () -> Void,
    isSaveDisabled: Bool = false
  ) -> some ToolbarContent {
    CustomNavigationBar(
      cancelAction: onCancel,
      saveAction: onSave,
      isSaveDisabled: isSaveDisabled
    )
  }
}

#Preview {
  NavigationStack {
    Text("Preview Content")
      .toolbar {
        CustomNavigationBar(
          cancelAction: { print("취소") },
          saveAction: { print("저장") },
          isSaveDisabled: false
        )
      }
  }
}

