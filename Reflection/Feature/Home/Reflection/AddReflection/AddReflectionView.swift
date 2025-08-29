//
//  AddReflectionView.swift
//  Reflection
//
//  Created by 현유진 on 8/22/25.
//

import SwiftUI

//// MARK: - 회고 추가 뷰
//struct AddReflectionView: View {
//  @Environment(\.modelContext) private var modelContext
//  @Environment(\.dismiss) private var dismiss
//  @StateObject private var addReflectionViewModel: AddReflectionViewModel = AddReflectionViewModel()
//  @AppStorage("fontSize") private var fontSize = 16.0
//  
//  var body: some View {
//    NavigationStack {
//      Form {
//        BasicInfoSectionView(addReflectionViewModel: addReflectionViewModel)
//        
//        ContentSectionView(content: $addReflectionViewModel.content)
//        
//        TagsSectionView(addReflectionViewModel: addReflectionViewModel)
//      }
//      .navigationTitle("새 회고")
//      .navigationBarTitleDisplayMode(.inline)
//      .toolbar {
//        CustomNavigationBar.standard(
//          onCancel: {
//            dismiss()
//          },
//          onSave: {
//            addReflectionViewModel.saveReflection(dismiss: dismiss)
//          },
//          isSaveDisabled: (
//            addReflectionViewModel.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
//            addReflectionViewModel.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
//          )
//        )
//      }
//    }
//    .font(.system(size: fontSize))
//  }
//}
//
//// MARK: - 기본 정보 섹션 뷰
//private struct BasicInfoSectionView: View {
//  @ObservedObject private var addReflectionViewModel: AddReflectionViewModel
//  
//  fileprivate init(addReflectionViewModel: AddReflectionViewModel) {
//    self.addReflectionViewModel = addReflectionViewModel
//  }
//  
//  fileprivate var body: some View {
//    Section("기본 정보") {
//      TitleFieldView(title: $addReflectionViewModel.title)
//      CategoryPickerView(selectedCategory: $addReflectionViewModel.selectedCategory)
//    }
//  }
//}
//
//// MARK: - 제목 필드 뷰
//private struct TitleFieldView: View {
//  @Binding var title: String
//  
//  fileprivate var body: some View {
//    TextField("제목", text: $title)
//      .font(.headline)
//  }
//}
//
//// MARK: - 카테고리 선택 뷰
//private struct CategoryPickerView: View {
//  @Binding var selectedCategory: ReflectionCategory
//  
//  fileprivate var body: some View {
//    Picker("카테고리", selection: $selectedCategory) {
//      ForEach(ReflectionCategory.allCases, id: \.self) { category in
//        HStack {
//          Image(systemName: category.icon)
//            .foregroundColor(Color(category.color))
//          Text(category.rawValue)
//        }
//        .tag(category)
//      }
//    }
//  }
//}
//
//// MARK: - 컨텐츠 섹션 뷰
//private struct ContentSectionView: View {
//  @Binding var content: String
//  
//  fileprivate var body: some View {
//    Section("내용") {
//      TextField(
//        "회고 내용을 작성해주세요",
//        text: $content,
//        axis: .vertical
//      )
//      .lineLimit(5...15)
//    }
//  }
//}
//
//// MARK: - 태그 섹션 뷰
//private struct TagsSectionView: View {
//  @ObservedObject private var addReflectionViewModel: AddReflectionViewModel
//  
//  fileprivate init(addReflectionViewModel: AddReflectionViewModel) {
//    self.addReflectionViewModel = addReflectionViewModel
//  }
//  
//  fileprivate var body: some View {
//    Section("태그") {
//      HStack {
//        TextField(
//          "태그 입력",
//          text: $addReflectionViewModel.tagInput
//        )
//        
//        Button("추가") {
//          withAnimation(.easeInOut(duration: 0.3)) {
//            addReflectionViewModel.addTag()
//          }
//        }
//        .disabled(addReflectionViewModel.isTagInputEmpty)
//      }
//    }
//    
//    if !addReflectionViewModel.tags.isEmpty {
//      ForEach(addReflectionViewModel.tags.indices, id: \.self) { index in
//        if index < addReflectionViewModel.tags.count {
//          HStack {
//            Text("#\(addReflectionViewModel.tags[index])")
//
//            Button(
//              action: {
//                addReflectionViewModel.removeTagAt(index)
//              },
//              label: {
//                Image(systemName: "xmark.circle.fill")
//                  .foregroundColor(.secondary)
//              }
//            )
//          }
//          .padding(.horizontal, 8)
//          .padding(.vertical, 4)
//          .background(Color.secondary.opacity(0.2))
//          .cornerRadius(8)
//        }
//      }
//    }
//  }
//}

//#Preview {
//  AddReflectionView()
//}
