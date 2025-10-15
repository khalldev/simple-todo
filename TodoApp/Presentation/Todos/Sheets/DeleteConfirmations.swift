//
//  DeleteConfirmations.swift
//  TodoApp
//
//  Created by Khal on 15/10/25.
//

import SwiftUI

struct DeleteConfirmationView: View {
  var onConfirm: () -> Void
  var onCancel: () -> Void

  var body: some View {
    ZStack {
      VStack(spacing: 20) {
        Text("Are you sure?")
          .font(.customHeadline)
          .fontWeight(.bold)
          .foregroundColor(.white)

        HStack(spacing: 30) {
          Button(action: onCancel) {
            Text("Cancel")
              .font(.customHeadline)
              .foregroundColor(.white)
              .padding()
              .frame(maxWidth: .infinity)
              .background(Color.gray.opacity(0.5))
              .cornerRadius(10)
          }

          Button(action: onConfirm) {
            Text("Delete")
              .font(.customHeadline)
              .foregroundColor(.white)
              .padding()
              .frame(maxWidth: .infinity)
              .background(Color.red)
              .cornerRadius(10)
          }
        }
        .padding(.horizontal)
      }
    }
    .colorScheme(.dark)
  }
}
