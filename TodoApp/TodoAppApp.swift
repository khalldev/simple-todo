//
//  TodoAppApp.swift
//  TodoApp
//
//  Created by Khal on 29/9/25.
//

import SwiftData
import SwiftUI

@main
struct TodoAppApp: App {
  var body: some Scene {
    WindowGroup {
      MainContentView()
    }
    .modelContainer(for: TodoStore.self)
  }
}
