//
//  SummaryView.swift
//  TodoApp
//
//  Created by Khal on 15/10/25.
//

import SwiftUI

struct SummaryContentView: View {
  var undoneTodosCount: Int
  var doneTodosCount: Int

  var body: some View {
    HStack {
      VStack(alignment: .center) {
        Text("\(undoneTodosCount)")
          .font(.customTitle)
          .fontWeight(.bold)
          .contentTransition(.numericText())
          .animation(.spring(response: 0.3, dampingFraction: 0.7), value: undoneTodosCount)
        Text("To Do")
          .font(.customBody)
      }
      .foregroundColor(.white)

      Spacer()

      VStack(alignment: .center) {
        Text("\(doneTodosCount)")
          .font(.customTitle)
          .fontWeight(.bold)
          .contentTransition(.numericText())
          .animation(.spring(response: 0.3, dampingFraction: 0.7), value: undoneTodosCount)
        Text("Done")
          .font(.customBody)
      }
      .foregroundColor(Color.terminalGreen)
    }
    .padding()
    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
    .padding(.horizontal, 24)
    .glassEffect(in: .rect(cornerRadius: 16.0))
    .padding(.bottom, 24)
  }
}
