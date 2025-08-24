//
//  ReflectionModelView.swift
//  Reflection
//
//  Created by 현유진 on 8/22/25.
//

import Foundation
import SwiftData
import SwiftUICore

// MARK: - 회고 모델
@Model
final class Reflection {
  var id: UUID
  var title: String
  var content: String
  var category: ReflectionCategory
  var tags: [String]
  var createdAt: Date
  var updatedAt: Date
  
  init(title: String, content: String, category: ReflectionCategory, tags: [String] = []) {
    self.id = UUID()
    self.title = title
    self.content = content
    self.category = category
    self.tags = tags
    self.createdAt = Date()
    self.updatedAt = Date()
  }
  
  func updateContent(title: String, content: String, category: ReflectionCategory, tags: [String]) {
    self.title = title
    self.content = content
    self.category = category
    self.tags = tags
    self.updatedAt = Date()
  }
}

// MARK: - 카테고리 열거형
enum ReflectionCategory: String, CaseIterable, Codable {
  case learning = "학습"
  case teamwork = "팀워크"
  case emotion = "감정"
  case project = "프로젝트"
  case career = "커리어"
  case personal = "개인"
  
  var icon: String {
    switch self {
    case .learning: return "book.fill"
    case .teamwork: return "person.3.fill"
    case .emotion: return "heart.fill"
    case .project: return "folder.fill"
    case .career: return "briefcase.fill"
    case .personal: return "person.fill"
    }
  }
  
  var color: Color {
    switch self {
    case .learning: return .blue
    case .teamwork: return .green
    case .emotion: return .pink
    case .project: return .orange
    case .career: return .purple
    case .personal: return .indigo
    }
  }
}
