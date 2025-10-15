//
//  MarkdownDataView.swift
//  TodoApp
//
//  Created by Khal on 14/10/25.
//

import SwiftUI

extension String {
  var unescaped: String {
    replacingOccurrences(of: "\\n", with: "\n")
      .replacingOccurrences(of: "\\\"", with: "\"")
  }

  var cleanedMarkdownList: String {
    // Replace "*   " (any spaces after *) with "* "
    replacingOccurrences(of: "\\*\\s+", with: "* ", options: .regularExpression)
  }
}

struct MarkdownDataView: View {
  private let markdown = "*   I'm not too sure either.\n*   I'm not really sure either.\n*   I don't really know either."
  var body: some View {
    VStack(alignment: .leading) {
      ScrollView {
        Text(.init(markdown.unescaped.cleanedMarkdownList))
          .font(.customBody)
          .contentTransition(.numericText())
          .multilineTextAlignment(.leading)
          .lineSpacing(10)
      }
    }
    .padding(12)
  }
}

#Preview {
  MarkdownDataView()
}
