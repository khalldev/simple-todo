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
  @StateObject private var geminiService = GeminiService()
  @State private var newTitle: String = "Belajar Berenang"
  @State private var newDescription: String = ""
  @State private var newEmoji: String = ""
  @State private var showEmojiPicker = false
  private let suggestions = ["Plan a trip to beach 🏖️", "Finish SwiftUI project 👨‍💻", "Read a book 📚", "Go for a run 🏃‍♀️"]

  var body: some View {
    NavigationView {
      VStack(alignment: .leading) {
        HStack(alignment: .center) {
          ZStack(alignment: .topLeading) {
            if newTitle.isEmpty {
              SuggestionTypingView(suggestions: suggestions)
                .padding(.leading, 5)
                .padding(.top, 12)
            }
            VStack {
              HStack {
                TextField("", text: $newTitle, axis: .vertical)
                  .lineLimit(1 ... 8) // min and max
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
          .textInputAutocapitalization(.none)
          .disableAutocorrection(true)
          .padding(.horizontal, 12)
          .padding(.vertical, 0)
          .cornerRadius(10)
          .padding()
          .font(.customBody)
          .glassEffect(in: .rect(cornerRadius: 16))
        }

        HStack {
          Text(geminiService.generatedDescription)
            .contentTransition(.numericText())
            .animation(.spring(), value: geminiService.generatedDescription)
            .frame(minHeight: 72, maxHeight: 420)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .cornerRadius(10)
            .frame(width: .infinity)
            .font(.customBody)
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .bottomTrailing) {
          if !newTitle.isEmpty {
            Button(action: {
              geminiService.generateDescription(for: newTitle)
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
            .disabled(newTitle.isEmpty || geminiService.isGenerating)
            .glassEffect(in: .rect(cornerRadius: 200))
            .padding()
          }
        }
        .glassEffect(in: .rect(cornerRadius: 16))
        .padding(.top, 16)
        .onChange(of: geminiService.generatedDescription) {
          newDescription = geminiService.generatedDescription
        }

//        HStack {
//
//        }
//        .frame(width: .infinity)
//        .padding(.horizontal)
//        .glassEffect(in: .rect(cornerRadius: 16))
//        .padding(.top, 16)
//        .onChange(of: geminiService.generatedDescription) {
//          newDescription = geminiService.generatedDescription
//        }
      }
      .padding()
      .navigationBarTitle("Add Todo", displayMode: .inline)
      .navigationBarItems(leading: Button("Cancel") {
        presentationMode.wrappedValue.dismiss()
      }, trailing: Button("Save") {
        addTodo()
        presentationMode.wrappedValue.dismiss()
      })
    }
    .sheet(isPresented: $showEmojiPicker) {
      EmojiPicker(selectedEmoji: $newEmoji)
        .presentationDetents([.height(600)])
    }
  }

  func addTodo() {
    let trimmed = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return }
    let newTodo = TodoStore(title: trimmed, todoDescription: newDescription, emoji: newEmoji)
    modelContext.insert(newTodo)
  }
}

#Preview("Add Form Todo List") {
  AddTodoView()
}

struct _ContentView: View {
  // 1. State variable to control the sheet's visibility
  @State private var isShowingBottomSheet = false

  var body: some View {
    ZStack {
      // Background content to show through the glass effect
      LinearGradient(
        gradient: Gradient(colors: [Color.purple, Color.blue.opacity(0.7), Color.red]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .ignoresSafeArea()

      VStack(spacing: 20) {
        Text("Content Behind Sheet")
          .font(.largeTitle)
          .fontWeight(.bold)
        Image(systemName: "star.fill")
          .font(.system(size: 100))
      }
      .foregroundColor(.white.opacity(0.8))

      // A simple button to trigger the sheet
      VStack {
        Spacer()
        Button("Show Glass Bottom Sheet") {
          isShowingBottomSheet.toggle()
        }
        .font(.headline)
        .padding()
        .background(.black.opacity(0.4))
        .foregroundColor(.white)
        .cornerRadius(16)
        .shadow(radius: 10)
      }
    }
    // 2. The sheet modifier that presents our content
    .sheet(isPresented: $isShowingBottomSheet) {
      SheetContentView()
        // 3. Set the height of the sheet (e.g., half the screen)
        .presentationDetents([.medium, .large])
      // 4. This is the magic! Apply the glass material background
    }
  }
}

// This is the view that will be displayed inside the bottom sheet
struct SheetContentView: View {
  // An environment variable to allow dismissing the sheet from within
  @Environment(\.dismiss) var dismiss

  var body: some View {
    VStack(spacing: 25) {
      Text("Glassmorphism Sheet")
        .font(.title)
        .fontWeight(.semibold)

      Text("This view is presented with a blurred, translucent background that shows the content behind it.")
        .multilineTextAlignment(.center)
        .padding(.horizontal)

      Button("Done") {
        dismiss() // Action to close the sheet
      }
      .font(.headline)
      .foregroundColor(.white)
      .padding(.horizontal, 50)
      .padding(.vertical, 12)
      .background(Color.blue)
      .cornerRadius(20)
    }
    .padding()
  }
}

#Preview {
  _ContentView()
}

struct SettingsSheet: View {
  @State
  private var currentDetent: PresentationDetent = .medium

  var body: some View {
    NavigationStack {
      Form {
        NotificationsSection(currentDetent: currentDetent)
      }
    }
    .presentationDetents(
      [.medium, .large], selection: $currentDetent
    )
  }
}

struct NotificationsSection: View {
  let currentDetent: PresentationDetent

  var body: some View {
    Section {
      NavigationLink("Notifications") {
        Form {}
          .scrollContentBackground(
            currentDetent == .medium ? .hidden : .automatic
          )
          .containerBackground(.clear, for: .navigation)
          .navigationTitle("Notifications")
      }
    }
  }
}
