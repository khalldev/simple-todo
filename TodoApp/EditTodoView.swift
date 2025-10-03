
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

  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      NavigationView {
        Form {
          Section(header: Text("Edit Todo")) {
            HStack {
              TextField("Enter title", text: $todo.title)
                .font(.customBody)
              Button(action: {
                showEmojiPicker.toggle()
              }) {
                Text(todo.emoji?.isEmpty == false ? todo.emoji! : "😀")
                  .font(.largeTitle)
              }
            }
          }
        }
        .navigationBarTitle("Edit Todo", displayMode: .inline)
        .navigationBarItems(leading: Button("Cancel") {
          presentationMode.wrappedValue.dismiss()
        }, trailing: Button("Save") {  presentationMode.wrappedValue.dismiss()
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
}
