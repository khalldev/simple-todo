

//
//  ContentView.swift
//  TodoApp
//
//  Created by Khal on 29/9/25.
//

import SwiftData
import SwiftUI

struct GlassEffectContainerCustome<Content: View>: View {
  let content: Content

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  var body: some View {
    content
      .padding()
      .background(
        VisualEffectView(effect: UIBlurEffect(style: .dark))
      )
      .cornerRadius(15)
  }
}

struct VisualEffectView: UIViewRepresentable {
  var effect: UIVisualEffect?
  func makeUIView(context _: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
  func updateUIView(_ uiView: UIVisualEffectView, context _: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct TodoRow: View {
  let todo: TodoStore
  let onToggle: () -> Void
  let onDelete: () -> Void

  var body: some View {
    HStack(spacing: 15) {
      Button(action: onToggle) {
        Image(systemName: todo.isCompleted ? "largecircle.fill.circle" : "circle")
          .font(.title2)
          .foregroundStyle(todo.isCompleted ? Color.terminalGreen : .white)
      }
      .buttonStyle(.glass)
      .animation(.bouncy, value: todo.isCompleted)

      if let emoji = todo.emoji, !emoji.isEmpty {
        Text(emoji)
          .font(.title)
      }

      Text(todo.title)
        .font(.customBody)
        .strikethrough(todo.isCompleted)
        .foregroundStyle(todo.isCompleted ? .white.opacity(0.5) : .white)
        .animation(.smooth, value: todo.isCompleted)
        .animation(.spring(), value: todo.title)

      Spacer()

      Button(role: .destructive, action: onDelete) {
        Image(systemName: "multiply.circle.fill")
          .foregroundStyle(.red)
      }
      .buttonStyle(.glass)
    }
    .padding()
    .background(
      ZStack {
        VisualEffectView(effect: UIBlurEffect(style: .dark))
        if todo.isCompleted {
          Color.terminalGreen.opacity(0.2)
        }
      }
    )
    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
  }
}

struct MainContentView: View {
  @State var search: String = ""
  var body: some View {
    TabView {
      Tab("List", systemImage: "list.bullet.indent") {
        TodoListContentView(search: search)
      }
      Tab("Links", systemImage: "link.circle.fill") {
        SettingsView()
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
    .accentColor(Color.terminalGreen)
    .searchable(text: $search)
    .font(.customBody)
    .foregroundStyle(.white)
  }
}

struct ContentView_Previews: PreviewProvider {
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
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \TodoStore.createdAt, order: .reverse) private var todos: [TodoStore]
  @State private var showAddTodoSheet = false
  @State private var selectedTodo: TodoStore? = nil
  @State private var showDeleteConfirmation = false
  @State private var todoToDelete: TodoStore? = nil
  var search: String = ""

  private var filteredTodos: [TodoStore] {
    if search.isEmpty {
      return todos
    } else {
      return todos.filter { $0.title.localizedCaseInsensitiveContains(search) }
    }
  }

  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      VStack {
        HStack {
          Text("Simplist")
            .font(.customHeadline)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding()

          Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)

        if todos.isEmpty {
          VStack {
            Spacer()
            Text("Ready to conquer your day? Add your first todo and let's get started!")
              .font(.customBody)
              .multilineTextAlignment(.center)
              .foregroundStyle(.white)
              .padding(.horizontal, 32)
            Spacer()
          }
        } else if filteredTodos.isEmpty {
          VStack {
            Spacer()
            Text("No results found for \"\(search)\"")
              .font(.customBody)
              .multilineTextAlignment(.center)
              .foregroundStyle(.white)
              .padding(.horizontal, 32)
              .animation(.spring, value: search)
            Spacer()
          }
        } else {
          ScrollView {
            VStack(spacing: 15) {
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
              }
            }
            .padding(.horizontal)
          }
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
          .presentationDetents([.height(220)])
      }
      .sheet(item: $selectedTodo) { todo in
        EditTodoView(todo: todo)
          .presentationDetents([.height(220)])
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
  }

  func toggleTodo(_ todo: TodoStore) {
    todo.isCompleted.toggle()
  }

  func deleteTodo(_ todo: TodoStore) {
    modelContext.delete(todo)
  }
}

struct DeleteConfirmationView: View {
  var onConfirm: () -> Void
  var onCancel: () -> Void

  var body: some View {
    ZStack {
      VisualEffectView(effect: UIBlurEffect(style: .dark))
        .ignoresSafeArea()
      VStack(spacing: 20) {
        Text("Are you sure?")
          .font(.customHeadline)
          .fontWeight(.bold)
          .foregroundColor(.white)

        HStack(spacing: 30) {
          Button(action: onCancel) {
            Text("Cancel")
              .font(.customHeadline)
              .foregroundColor(.white)
              .padding()
              .frame(maxWidth: .infinity)
              .background(Color.gray.opacity(0.5))
              .cornerRadius(10)
          }

          Button(action: onConfirm) {
            Text("Delete")
              .font(.customHeadline)
              .foregroundColor(.white)
              .padding()
              .frame(maxWidth: .infinity)
              .background(Color.red)
              .cornerRadius(10)
          }
        }
        .padding(.horizontal)
      }
    }
    .colorScheme(.dark)
  }
}
