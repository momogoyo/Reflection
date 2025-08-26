//
//  ReflectionListView.swift
//  Reflection
//
//  Created by 현유진 on 8/22/25.
//

import SwiftUI
import SwiftData

// MARK: - 회고 목록 뷰
struct ReflectionListView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Reflection.createdAt, order: .reverse) private var reflections: [Reflection]
  @StateObject private var reflectionListViewModel: ReflectionListViewModel = ReflectionListViewModel()
  @AppStorage("fontSize") private var fontSize = 16.0
  
  private var filteredReflections: [Reflection] {
    reflectionListViewModel.filteredReflections(from: reflections)
  }
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        CategoryFilterSectionView(reflectionListViewModel: reflectionListViewModel)
          .padding(.vertical, 8)
        
        ReflectionListSectionView(
          reflections: filteredReflections,
          searchText: $reflectionListViewModel.searchText,
          onDelete: { offsets in
            withAnimation {
              reflectionListViewModel.deleteReflections(
                at: offsets,
                from: reflectionListViewModel.filteredReflections(from: filteredReflections)
              )
            }
          }
        )
      }
      .navigationTitle("회고 저장소")
      .toolbar {
        CustomNavigationBar.addOnly(
          onAdd: {
            reflectionListViewModel.showingAddReflection = true
          }
        )
      }
      .sheet(isPresented: $reflectionListViewModel.showingAddReflection) {
        AddReflectionView()
      }
    }
    .font(.system(size: fontSize))
  }
}

// MARK: - 카테고리 필터 섹션 뷰
private struct CategoryFilterSectionView: View {
  @ObservedObject private var reflectionListViewModel: ReflectionListViewModel
  
  fileprivate init(reflectionListViewModel: ReflectionListViewModel) {
    self.reflectionListViewModel = reflectionListViewModel
  }
  
  fileprivate var body: some View {
    ScrollView(
      .horizontal,
      showsIndicators: false
    ) {
      HStack {
        FilterButtonView(
          title: "전체",
          isSelected: reflectionListViewModel.selectedCategory == nil,
          action: {
            reflectionListViewModel.selectedCategory = nil
          }
        )
        
        ForEach(ReflectionCategory.allCases, id: \.self) { category in
          FilterButtonView(
            title: category.rawValue,
            isSelected: reflectionListViewModel.selectedCategory == category,
            action: {
              reflectionListViewModel.selectedCategory = category
            }
          )
        }
      }
      .padding(.horizontal)
    }
  }
}

// MARK: - 필터 버튼 뷰
private struct FilterButtonView: View {
  let title: String
  let isSelected: Bool
  let action: () -> Void
  
  fileprivate init(
    title: String = "",
    isSelected: Bool = false,
    action: @escaping () -> Void = { }
  ) {
    self.title = title
    self.isSelected = isSelected
    self.action = action
  }
  
  fileprivate var body: some View {
    Button(
      action: action,
      label: {
        Text(title)
          .font(.subheadline)
          .padding(.horizontal, 16)
          .padding(.vertical, 8)
          .background(isSelected ? Color.accentColor : Color.secondary.opacity(0.2))
          .foregroundColor(isSelected ? .white : .primary)
          .cornerRadius(20)
      }
    )
  }
}

// MARK: - 회고 목록 섹션 뷰
private struct ReflectionListSectionView: View {
  let reflections: [Reflection]
  @Binding var searchText: String
  let onDelete: (IndexSet) -> Void
  
  fileprivate var body: some View {
    List {
      ForEach(reflections) { reflection in
        NavigationLink(
          destination: ReflectionDetailView(reflection: reflection)
        ) {
          ReflectionRowView(reflection: reflection)
        }
      }
      .onDelete(perform: onDelete)
    }
    .searchable(
      text: $searchText,
      prompt: "회고 검색"
    )
  }
}

// MARK: - 회고 행 뷰
struct ReflectionRowView: View {
  let reflection: Reflection
  @AppStorage("fontSize") private var fontSize = 16.0
  
  var body: some View {
    VStack(
      alignment: .leading,
      spacing: 8
    ) {
      HStack {
        Image(systemName: reflection.category.icon)
          .foregroundColor(Color(reflection.category.color))
          .frame(width: 20)
        
        Text(reflection.title)
          .font(.headline.weight(.medium))
          .lineLimit(1)
        
        Spacer()
        
        Text(
          reflection.createdAt,
          style: .date
        )
        .font(.caption)
        .foregroundColor(.secondary)
      }
      
      Text(reflection.content)
        .font(.body)
        .foregroundColor(.secondary)
        .lineLimit(2)
      
      if !reflection.tags.isEmpty {
        ScrollView(
          .horizontal,
          showsIndicators: false
        ) {
          HStack {
            ForEach(reflection.tags, id: \.self) { tag in
              Text("#\(tag)")
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(8)
            }
          }
        }
      }
    }
    .padding(.vertical, 4)
    .font(.system(size: fontSize))
  }
}

#Preview {
  ReflectionListView()
}
