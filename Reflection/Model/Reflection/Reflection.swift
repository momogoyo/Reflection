//
//  ReflectionModelView.swift
//  Reflection
//
//  Created by 현유진 on 8/22/25.
//

import Foundation
import SwiftData

// MARK: - 회고 모델
@Model
class Reflection {
  var id: UUID
  var title: String
  var content: String
  var category: ReflectionCategory
  var tags: [String]
  var createdAt: Date
  var updatedAt: Date
  
  init(
    title: String,
    content: String,
    category: ReflectionCategory,
    tags: [String] = []
  ) {
    self.id = UUID()
    self.title = title
    self.content = content
    self.category = category
    self.tags = tags
    self.createdAt = Date()
    self.updatedAt = Date()
  }
  
  func updateContent(
    title: String,
    content: String,
    category: ReflectionCategory,
    tags: [String]
  ) {
    self.title = title
    self.content = content
    self.category = category
    self.tags = tags
    self.updatedAt = Date()
  }
}
