//
//  ContentView.swift
//  Reflection
//
//  Created by 현유진 on 8/22/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  /// SwiftData 컨텍스트. 데이터베이스 작업을 위한 관리자
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Reflection.createdAt, order: .reverse) private var reflections: [Reflection]
  
  /// UserDefault에 저장
  /// @AppStorage("식별자")
  @AppStorage("selectedTab") private var selectedTab = 0
  @AppStorage("isDarkMode") private var isDarkMode = false
  @AppStorage("fontSize") private var fontSize = 16.0
  
  var body: some View {
    TabView(selection: $selectedTab) {
      // 회고 목록 탭
      ReflectionListView()
        .tabItem {
          Image(systemName: "book.fill")
          Text("회고")
        }
        .tag(0)
      
      // 통계 탭
//      StatisticsView()
//        .tabItem {
//          Image(systemName: "chart.bar.fill")
//          Text("통계")
//        }
//        .tag(1)
      
      // 설정 탭
      SettingsView()
        .tabItem {
          Image(systemName: "gear")
          Text("설정")
        }
        .tag(2)
    }
    .preferredColorScheme(
      isDarkMode
      ? .dark
      : nil
    )
    /// 사용자가 설정한 폰트를 앱에서 어디까지 지원할지 설정
    /// 모든 크기를 지원하되, 최대 accessibility2(접근성 2단계)까지
    .dynamicTypeSize(...DynamicTypeSize.accessibility2)
  }
}

#Preview {
  ContentView()
    .modelContainer(
      for: Reflection.self,
      inMemory: true
    )
}
