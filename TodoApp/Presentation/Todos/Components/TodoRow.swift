//
//  TodoRow.swift
//  TodoApp
//
//  Created by Khal on 15/10/25.
//

import SwiftUI

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
      .buttonStyle(.plain)
      .animation(.bouncy, value: todo.isCompleted)
      .glassEffect(in: .rect(cornerRadius: 16.0))

      if let emoji = todo.emoji, !emoji.isEmpty {
        Text(emoji)
          .font(.customBody)
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
          .glassEffect(in: .rect(cornerRadius: 16.0))
      }
      .buttonStyle(.plain)
    }
    .padding()
    .glassEffect(in: .rect(cornerRadius: 16.0))
  }
}
