import SwiftUI

private struct TitleInputView: View {
  @Binding var title: String
  @Binding var emoji: String
  let onShowEmojiPicker: () -> Void
  private let suggestions = ["Plan a trip to beach 🏖️", "Finish SwiftUI project 👨‍💻", "Read a book 📚", "Go for a run 🏃‍♀️"]

  var body: some View {
    HStack(alignment: .center) {
      ZStack(alignment: .topLeading) {
        if title.isEmpty {
          SuggestionTypingView(suggestions: suggestions)
            .padding(.leading, 5)
            .padding(.top, 12)
        }
        VStack {
          HStack {
            TextField("", text: $title, axis: .vertical)
              .lineLimit(1 ... 8)
            Button(action: onShowEmojiPicker) {
              Text(emoji.isEmpty ? "😀" : emoji)
                .font(.largeTitle)
                .glassEffect()
            }
            .glassEffect(in: .rect(cornerRadius: 16))
          }
        }
      }
      .textInputAutocapitalization(.none)
      .disableAutocorrection(true)
      .padding(.horizontal, 12)
      .padding(.vertical, 0)
      .cornerRadius(10)
      .padding()
      .font(.customBody)
      .glassEffect(in: .rect(cornerRadius: 16))
    }
  }
}

private struct DescriptionView: View {
  @ObservedObject var geminiService: HgFaceService
  @Binding var title: String
  @Binding var description: String

  var body: some View {
    Text(geminiService.generatedDescription)
      .contentTransition(.numericText())
      .multilineTextAlignment(.leading)
      .lineSpacing(10)
      .animation(.spring(), value: geminiService.generatedDescription)
      .padding(.horizontal, 16)
      .padding(.vertical, 16)
      .frame(minHeight: 72)
      .cornerRadius(10)
      .font(.customBody)
      .frame(maxWidth: .infinity)
      .overlay(alignment: .bottomTrailing) {
        if !title.isEmpty {
          Button(action: {
            geminiService.generateDescription(for: title)
          }) {
            if geminiService.isGenerating {
              ProgressView()
                .padding(10)
            } else {
              Image(systemName: "sparkles")
                .font(.system(size: 24))
                .padding(10)
            }
          }
          .disabled(title.isEmpty || geminiService.isGenerating)
          .glassEffect(in: .rect(cornerRadius: 200))
          .padding()
        }
      }
      .glassEffect(in: .rect(cornerRadius: 16))
      .padding(.top, 16)
      .onChange(of: geminiService.generatedDescription) {
        description = geminiService.generatedDescription
      }
      .onAppear {
        geminiService.generatedDescription = description
      }
  }
}

struct TodoFormView: View {
  @Binding var title: String
  @Binding var description: String
  @Binding var emoji: String
  @StateObject private var geminiService = HgFaceService()
  @State private var showEmojiPicker = false

  var body: some View {
    VStack(alignment: .leading) {
      TitleInputView(title: $title, emoji: $emoji) {
        showEmojiPicker.toggle()
      }

      DescriptionView(geminiService: geminiService, title: $title, description: $description)

      Spacer()
    }
    .sheet(isPresented: $showEmojiPicker) {
      EmojiPicker(selectedEmoji: $emoji)
        .presentationDetents([.height(600)])
    }
  }
}
