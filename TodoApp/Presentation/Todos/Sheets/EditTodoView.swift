import SwiftUI

struct EditTodoView: View {
  @Environment(\.presentationMode) var presentationMode
  @Bindable var todo: TodoStore

  private var todoDescription: Binding<String> {
    Binding(
      get: { todo.todoDescription },
      set: { todo.todoDescription = $0 }
    )
  }

  private var todoEmoji: Binding<String> {
    Binding(
      get: { todo.emoji ?? "" },
      set: { todo.emoji = $0 }
    )
  }

  var body: some View {
    NavigationView {
      VStack {
        TodoFormView(
          title: $todo.title,
          description: todoDescription,
          emoji: todoEmoji
        )
      }
      .padding()
      .navigationBarTitle("Edit Todo", displayMode: .inline)
      .navigationBarItems(leading: Button("Cancel") {
        presentationMode.wrappedValue.dismiss()
      }, trailing: Button("Save") {
        presentationMode.wrappedValue.dismiss()
      })
    }
    .colorScheme(.dark)
  }
}
