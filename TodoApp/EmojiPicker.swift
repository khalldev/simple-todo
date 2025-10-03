
//
//  EmojiPicker.swift
//  TodoApp
//
//  Created by Khal on 29/9/25.
//

import SwiftUI

struct EmojiPicker: View {
  @Binding var selectedEmoji: String
  @Environment(\.presentationMode) var presentationMode

  let emojiCategories = [
    ("Smileys & People", ["😀", "😂", "🥰", "🤔", "😴"]),
    ("Animals & Nature", ["🐶", "🐱", "🐭", "🐹", "🐰"]),
    ("Food & Drink", ["🍏", "🍎", "🍐", "🍊", "🍋"]),
    ("Activities", ["⚽️", "🏀", "🏈", "⚾️", "🥎"]),
    ("Travel & Places", ["🚗", "🚕", "🚙", "🚌", "🚎"]),
    ("Objects", ["⌚️", "📱", "📲", "💻", "⌨️"]),
    ("Symbols", ["❤️", "💔", "💕", "💞", "💓"]),
    ("Flags", ["🏳️", "🏴", "🏁", "🚩"]),
  ]

  var body: some View {
    ZStack {
      VisualEffectView(effect: UIBlurEffect(style: .dark))
        .ignoresSafeArea()
      VStack {
        HStack {
          Text("Select an Emoji")
            .font(.customHeadline)
            .foregroundColor(.white)
          Spacer()
          Button(action: {
            presentationMode.wrappedValue.dismiss()
          }) {
            Image(systemName: "xmark.circle.fill")
              .font(.title)
              .foregroundColor(.white)
          }
        }
        .padding()

        ScrollView {
          ForEach(emojiCategories, id: \.0) { category in
            VStack(alignment: .leading) {
              Text(category.0)
                .font(.customHeadline)
                .foregroundColor(.white)
                .padding(.leading)
              LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
                ForEach(category.1, id: \.self) { emoji in
                  Button(action: {
                    selectedEmoji = emoji
                    presentationMode.wrappedValue.dismiss()
                  }) {
                    Text(emoji)
                      .font(.largeTitle)
                      .padding(5)
                      .background(Color.gray.opacity(0.2))
                      .cornerRadius(10)
                  }
                }
              }
              .padding(.horizontal)
              .padding(.bottom, 20)
            }
          }
        }
      }
      .colorScheme(.dark)
    }
  }
}

#if DEBUG
  struct EmojiPicker_Previews: PreviewProvider {
    static var previews: some View {
      EmojiPicker(selectedEmoji: .constant("😀"))
    }
  }
#endif
