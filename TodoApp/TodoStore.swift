//
//  TodoStore.swift
//  TodoApp
//
//  Created by Khal on 29/9/25.
//

import Foundation
import SwiftData

@Model
final class TodoStore {
  @Attribute(.unique) var id: UUID
  var title: String
  var todoDescription: String
  var emoji: String?
  var isCompleted: Bool
  var createdAt: Date

  init(title: String, todoDescription: String = "", emoji: String? = nil, isCompleted: Bool = false, createdAt: Date = .now) {
    id = UUID()
    self.title = title
    self.todoDescription = todoDescription
    self.emoji = emoji
    self.isCompleted = isCompleted
    self.createdAt = createdAt
  }
}
