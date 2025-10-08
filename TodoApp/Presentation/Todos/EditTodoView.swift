
//
//  EditTodoView.swift
//  TodoApp
//
//  Created by Khal on 29/9/25.
//

import SwiftUI

struct EditTodoView: View {
  @Environment(\.presentationMode) var presentationMode
  @Bindable var todo: TodoStore
  @State private var showEmojiPicker = false
  private let suggestions = ["Plan a trip to beach 🏖️", "Finish SwiftUI project 👨‍💻", "Read a book 📚", "Go for a run 🏃‍♀️"]

  var body: some View {
    NavigationView {
      VStack {
        HStack(alignment: .center) {
          ZStack(alignment: .topLeading) {
            if todo.title.isEmpty {
              SuggestionTypingView(suggestions: suggestions)
                .padding(.leading, 5)
                .padding(.top, 12)
            }
            HStack {
              TextField("", text: $todo.title)
              Button(action: {
                showEmojiPicker.toggle()
              }) {
                Text(todo.emoji?.isEmpty == false ? todo.emoji! : "😀")
                  .font(.largeTitle)
                  .glassEffect()
              }
              .glassEffect()
            }
          }
          .textInputAutocapitalization(.none)
          .disableAutocorrection(true)
          .padding(.horizontal, 12)
          .padding(.vertical, 0)
          .cornerRadius(10)
          .padding()
          .font(.customBody)
          .glassEffect()
        }
      }
      .padding()
      .navigationBarTitle("Edit Todo", displayMode: .inline)
      .navigationBarItems(leading: Button("Cancel") {
        presentationMode.wrappedValue.dismiss()
      }, trailing: Button("Save") { presentationMode.wrappedValue.dismiss()
      })
    }
    .colorScheme(.dark)
    .sheet(isPresented: $showEmojiPicker) {
      EmojiPicker(selectedEmoji: Binding(
        get: { todo.emoji ?? "" },
        set: { todo.emoji = $0 }
      ))
      .presentationDetents([.height(200)])
    }
  }
}
