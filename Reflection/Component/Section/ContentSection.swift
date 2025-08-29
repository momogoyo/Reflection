//
//  ContentSection.swift
//  Reflection
//
//  Created by 현유진 on 8/29/25.
//

import SwiftUI

struct ContentSection: View {
  @Binding var content: String
  
  var body: some View {
    Section("내용") {
      TextField("회고 내용을 작성해주세요", text: $content, axis: .vertical)
        .lineLimit(5...15)
    }
  }
}
#Preview {
//  ContentSection()
}
