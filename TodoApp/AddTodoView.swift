//
//  AddTodoView.swift
//  TodoApp
//
//  Created by Khal on 3/10/25.
//

import SwiftData
import SwiftUI

struct AddTodoView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.presentationMode) var presentationMode
  @State private var newTitle: String = ""
  @State private var newEmoji: String = ""
  @State private var showEmojiPicker = false
  private let suggestions = ["Plan a trip to the beach 🏖️", "Finish my SwiftUI project 👨‍💻", "Read a book 📚", "Go for a run 🏃‍♀️"]

  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      NavigationView {
        Form {
          Section(header: Text("New Todo")) {
            HStack {
              GlassEffectContainer {
                ZStack(alignment: .topLeading) {
                  if newTitle.isEmpty {
                    SuggestionTypingView(suggestions: suggestions)
                      .padding(.top, 8)
                      .padding(.leading, 5)
                  }
                  TextEditor(text: $newTitle)
                    .font(.customBody)
                    .frame(maxHeight: 100)
                    .background(.clear)
                }
              }
              Button(action: {
                showEmojiPicker.toggle()
              }) {
                Text(newEmoji.isEmpty ? "😀" : newEmoji)
                  .font(.largeTitle)
                  .glassEffect()
              }
              .glassEffect()
            }
          }
        }
        .navigationBarTitle("Add Todo", displayMode: .inline)
        .navigationBarItems(
          leading: Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
          }
          .glassEffect(), trailing:
          Button("Save") {
            addTodo()
            presentationMode.wrappedValue.dismiss()
          }
          .glassEffect()
        )
      }

      .colorScheme(.dark)
      .sheet(isPresented: $showEmojiPicker) {
        EmojiPicker(selectedEmoji: $newEmoji)
          .presentationDetents([.height(600)])
      }
    }
  }

  func addTodo() {
    let trimmed = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return }
    let newTodo = TodoStore(title: trimmed, emoji: newEmoji)
    modelContext.insert(newTodo)
  }
}

#Preview("Add Form Todo List") {
  AddTodoView()
}
