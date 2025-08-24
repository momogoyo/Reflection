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
  @AppStorage("fontSize") private var fontSize = 16.0
  
  @State private var title = ""
  @State private var content = ""
  @State private var selectedCategory = ReflectionCategory.personal
  @State private var tags: [String] = []
  @State private var tagInput = ""
  
  var body: some View {
    NavigationStack {
      Form {
        Section("기본 정보") {
          TextField("제목", text: $title)
            .font(.headline)
          
          Picker("카테고리", selection: $selectedCategory) {
            ForEach(ReflectionCategory.allCases, id: \.self) { category in
              HStack {
                Image(systemName: category.icon)
                  .foregroundColor(Color(category.color))
                Text(category.rawValue)
              }
              .tag(category)
            }
          }
        }
        
        Section("내용") {
          TextField("회고 내용을 작성해주세요", text: $content, axis: .vertical)
            .lineLimit(5...15)
        }
        
        Section("태그") {
          HStack {
            TextField("태그 입력", text: $tagInput)
            Button("추가") {
              addTag()
            }
            .disabled(tagInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
          }
          
          if !tags.isEmpty {
            LazyVGrid(columns: [
              GridItem(.adaptive(minimum: 80))
            ], alignment: .leading, spacing: 8) {
              ForEach(Array(tags.enumerated()), id: \.offset) { index, tag in
                HStack {
                  Text("#\(tag)")
                  Button(action: { removeTag(at: index) }) {
                    Image(systemName: "xmark.circle.fill")
                      .foregroundColor(.secondary)
                  }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(8)
              }
            }
          }
        }
      }
      .navigationTitle("새 회고")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("취소") {
            dismiss()
          }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("저장") {
            saveReflection()
          }
          .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                    content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
      }
    }
    .font(.system(size: fontSize))
  }
  
  private func addTag() {
    let trimmedTag = tagInput.trimmingCharacters(in: .whitespacesAndNewlines)
    if !trimmedTag.isEmpty && !tags.contains(trimmedTag) {
      tags.append(trimmedTag)
      tagInput = ""
    }
  }
  
  private func removeTag(at index: Int) {
    tags.remove(at: index)
  }
  
  private func saveReflection() {
    let reflection = Reflection(
      title: title.trimmingCharacters(in: .whitespacesAndNewlines),
      content: content.trimmingCharacters(in: .whitespacesAndNewlines),
      category: selectedCategory,
      tags: tags
    )
    modelContext.insert(reflection)
    dismiss()
  }
}

#Preview {
  AddReflectionView()
}
