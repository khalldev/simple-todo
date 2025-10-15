

//
//  ContentView.swift
//  TodoApp
//
//  Created by Khal on 29/9/25.
//

import SwiftData
import SwiftUI

struct MainContentView: View {
  @State var search: String = ""
  @State private var selectedTab: Int = 0

  var body: some View {
    TabView {
      Tab("List", systemImage: "list.bullet.indent") {
        TodoListContentView(search: search)
      }

      Tab("Setting", systemImage: "gear") {
        SettingsView()
      }

      Tab("search", systemImage: "magnifyingglass", role: .search) {
        NavigationStack {
          TodoListContentView(search: search)
        }
      }
    }
    .tabBarMinimizeBehavior(.automatic)
    .searchable(text: $search)
    .accentColor(Color.terminalGreen)
    .font(.customBody)
    .foregroundStyle(.white)
  }
}

struct _ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let container = try! ModelContainer(for: TodoStore.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))

    let sampleTodos = [
      TodoStore(title: "Finish SwiftUI project", emoji: "👨‍💻", isCompleted: true),
      TodoStore(title: "Read a book", emoji: "📚"),
      TodoStore(title: "Go for a run", emoji: "🏃‍♀️"),
      TodoStore(title: "Buy groceries", emoji: "🛒"),
      TodoStore(title: "Walk the dog", emoji: "🐕"),
      TodoStore(title: "Call mom", emoji: "📱"),
      TodoStore(title: "Water the plants", emoji: "🌱"),
      TodoStore(title: "Clean the house", emoji: "🧹"),
      TodoStore(title: "Do laundry", emoji: "🧺"),
      TodoStore(title: "Meditate for 10 minutes", emoji: "🧘"),
      TodoStore(title: "Plan weekend trip", emoji: "🏕️"),
      TodoStore(title: "Learn a new recipe", emoji: "🍳"),
      TodoStore(title: "Watch a movie", emoji: "🎬"),
      TodoStore(title: "Write a blog post", emoji: "✍️"),
      TodoStore(title: "Organize closet", emoji: "👕"),
      TodoStore(title: "Pay bills", emoji: "🧾"),
      TodoStore(title: "Fix the leaky faucet", emoji: "🔧"),
      TodoStore(title: "Practice guitar", emoji: "🎸"),
      TodoStore(title: "Study for exam", emoji: "📖"),
      TodoStore(title: "Go to the gym", emoji: "💪"),
      TodoStore(title: "Bake a cake", emoji: "🎂"),
      TodoStore(title: "Take out the trash", emoji: "🗑️"),
    ]

    for todo in sampleTodos {
      container.mainContext.insert(todo)
    }

    return MainContentView()
      .modelContainer(container)
  }
}

struct TodoListContentView: View {
  var search: String = ""

  @Environment(\.modelContext) private var modelContext
  @Query(sort: \TodoStore.createdAt, order: .reverse) private var todos: [TodoStore]
  @State private var showAddTodoSheet = false
  @State private var selectedTodo: TodoStore? = nil
  @State private var showDeleteConfirmation = false
  @State private var todoToDelete: TodoStore? = nil

  init(search: String) {
    self.search = search

    let appearance = UINavigationBarAppearance()
    appearance.titleTextAttributes = [
      .font: UIFont.monospacedSystemFont(ofSize: 18, weight: .semibold),
    ]

    appearance.largeTitleTextAttributes = [
      .font: UIFont.monospacedSystemFont(ofSize: 34, weight: .bold),
    ]

    appearance.subtitleTextAttributes = [
      .font: UIFont.monospacedSystemFont(ofSize: 12, weight: .medium),
    ]

    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
    UINavigationBar.appearance().tintColor = .label
  }

  private var filteredTodos: [TodoStore] {
    if search.isEmpty {
      return todos
    } else {
      return todos.filter { $0.title.localizedCaseInsensitiveContains(search) }
    }
  }

  private var doneTodosCount: Int {
    todos.filter { $0.isCompleted }.count
  }

  private var undoneTodosCount: Int {
    todos.count - doneTodosCount
  }

  var body: some View {
    NavigationStack {
      ZStack {
        VStack {
          if todos.isEmpty {
            EmptyStateView(message: "Ready to conquer your day? Add your first todo and let's get started!")
          } else if filteredTodos.isEmpty {
            EmptyStateView(message: "No results found for \"\(search)\"")
              .animation(.spring, value: search)
          } else {
            List {
              if !todos.isEmpty {
                SummaryContentView(
                  undoneTodosCount: undoneTodosCount,
                  doneTodosCount: doneTodosCount,
                )
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
              }
              ForEach(filteredTodos) { todo in
                TodoRow(
                  todo: todo,
                  onToggle: { toggleTodo(todo) },
                  onDelete: { todoToDelete = todo
                    showDeleteConfirmation = true
                  }
                )
                .onTapGesture {
                  selectedTodo = todo
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
              }
            }
            .listStyle(.plain)
            .padding(.horizontal)
            .frame(maxWidth: 700)
            .animation(.default, value: filteredTodos)
          }

          Spacer()
        }

        VStack {
          Spacer()
          HStack {
            Spacer()
            Button(action: {
              showAddTodoSheet.toggle()
            }) {
              Text("Create +")
                .font(.customBody)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding()
                .glassEffect()
            }
            .padding()
          }
        }
        .sheet(isPresented: $showAddTodoSheet) {
          AddTodoView()
        }
        .sheet(item: $selectedTodo) { todo in
          EditTodoView(todo: todo)
        }
        .sheet(isPresented: $showDeleteConfirmation) {
          DeleteConfirmationView(
            onConfirm: {
              if let todo = todoToDelete {
                deleteTodo(todo)
                showDeleteConfirmation = false
              }
            },
            onCancel: { showDeleteConfirmation = false }
          )
          .presentationDetents([.height(150)])
        }
      }
      .navigationTitle("Simplist")
      .navigationSubtitle("Reminder u whats going on right now")
    }
  }

  func toggleTodo(_ todo: TodoStore) {
    todo.isCompleted.toggle()
  }

  func deleteTodo(_ todo: TodoStore) {
    modelContext.delete(todo)
  }

  func deleteTodoAtIndexSet(at offsets: IndexSet) {
    for index in offsets {
      let todo = filteredTodos[index]
      deleteTodo(todo)
    }
  }
}
