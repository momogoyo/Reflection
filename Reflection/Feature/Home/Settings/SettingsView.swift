//
//  SettingsView.swift
//  Reflection
//
//  Created by 현유진 on 8/22/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("fontSize") private var fontSize = 16.0
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    
    var body: some View {
        NavigationStack {
            Form {
                Section("외관") {
                    Toggle("다크 모드", isOn: $isDarkMode)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("글꼴 크기")
                        HStack {
                            Text("작게")
                                .font(.caption)
                            Slider(value: $fontSize, in: 12...24, step: 1)
                            Text("크게")
                                .font(.title3)
                        }
                        Text("현재 크기: \(Int(fontSize))pt")
                            .font(.system(size: fontSize))
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("앱 정보") {
                    HStack {
                        Text("버전")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("개발자")
                        Spacer()
                        Text("회고 시스템")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("데이터") {
                    Button("첫 실행 상태 초기화") {
                        isFirstLaunch = true
                    }
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("설정")
        }
        .font(.system(size: fontSize))
    }
}


#Preview {
    SettingsView()
}
