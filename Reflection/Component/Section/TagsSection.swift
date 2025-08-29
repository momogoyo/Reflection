//
//  TagsSection.swift
//  Reflection
//
//  Created by 현유진 on 8/29/25.
//

import SwiftUI

struct TagsSection: View {
  @Binding var tags: [String]
  @Binding var tagInput: String
  let onAddTag: () -> Void
  let onRemoveTag: (Int) -> Void
  let canAddTag: Bool
  
  var body: some View {
    Section("태그") {
      HStack {
        TextField("태그 입력", text: $tagInput)
        Button("추가", action: onAddTag)
          .disabled(!canAddTag)
      }
      
      if !tags.isEmpty {
        LazyVGrid(columns: [
          GridItem(.adaptive(minimum: 80))
        ], alignment: .leading, spacing: 8) {
          ForEach(tags, id: \.self) { tag in
            HStack {
              Text("#\(tag)")
              Button(action: {
                if let index = tags.firstIndex(of: tag) {
                  onRemoveTag(index)
                }
              }) {
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
}

#Preview {
  //    TagsSection()
}
