import SwiftData
import SwiftUI

struct AddTodoView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.presentationMode) var presentationMode

  @State private var newTitle: String = "Belajar Berenang"
  @State private var newDescription: String = ""
  @State private var newEmoji: String = ""

  var body: some View {
    NavigationView {
      VStack {
        TodoFormView(title: $newTitle, description: $newDescription, emoji: $newEmoji)
      }
      .padding()
      .navigationBarTitle("Add Todo", displayMode: .inline)
      .navigationBarItems(leading: Button("Cancel") {
        presentationMode.wrappedValue.dismiss()
      }, trailing: Button("Save") {
        addTodo()
        presentationMode.wrappedValue.dismiss()
      })
    }
  }

  func addTodo() {
    print(newTitle)
    let trimmed = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return }
    let newTodo = TodoStore(title: trimmed, todoDescription: newDescription, emoji: newEmoji)
    modelContext.insert(newTodo)
    try? modelContext.save()
  }
}

#Preview("Add Form Todo List") {
  AddTodoView()
}
