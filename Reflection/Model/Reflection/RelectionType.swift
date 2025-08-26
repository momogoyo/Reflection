//
//  RelectionType.swift
//  Reflection
//
//  Created by 현유진 on 8/25/25.
//

import Foundation
import SwiftUICore

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
