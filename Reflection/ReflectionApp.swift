//
//  ReflectionApp.swift
//  Reflection
//
//  Created by 현유진 on 8/22/25.
//

import SwiftUI

/// modelContainer: SwiftData에서 데이터베이스를 관리하는 컨테이너
/// Reflection을 위한 데이터베이스를 만들고 ReflectionApp 전체에서 사용할 수 있다.
/// SQLite DB 생성 / 테이블 구조 생성 / 인덱스 생성

@main
struct ReflectionApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .modelContainer(for: Reflection.self)
  }
}

#Preview {
  ContentView()
    .modelContainer(
      for: Reflection.self,
      inMemory: true
    )
}
