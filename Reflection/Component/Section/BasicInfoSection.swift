//
//  BasicInfoSection.swift
//  Reflection
//
//  Created by 현유진 on 8/29/25.
//

import SwiftUI

struct BasicInfoSection: View {
  @Binding var title: String
  @Binding var selectedCategory: ReflectionCategory
  
  var body: some View {
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
  }
}

#Preview {
  BasicInfoSection(
    title: .constant("이건 첫번째 레슨"),
    selectedCategory: .constant(.personal)
  )
}
