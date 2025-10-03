
import SwiftUI

struct SuggestionTypingView: View {
  let suggestions: [String]
  @State private var displayedText: String = ""
  @State private var currentSuggestionIndex: Int = 0
  @State private var isDeleting: Bool = false
  @State private var timer: Timer?

  var body: some View {
    Text(displayedText)
      .font(.customBody)
      .foregroundColor(.gray)
      .onAppear(perform: scheduleNextAnimation)
      .onDisappear(perform: cleanup)
      .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5), value: displayedText)
  }

  private func cleanup() {
    timer?.invalidate()
    timer = nil
  }

  private func scheduleNextAnimation() {
    cleanup()

    // Set a timer to perform the next action
    let delay = isDeleting ? 0.8 : 2.0 // Shorter delay before typing, longer before deleting
    timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
      if isDeleting {
        animateDeleting()
      } else {
        animateTyping()
      }
    }
  }

  private func animateTyping() {
    let suggestion = suggestions[currentSuggestionIndex]
    var charIndex = 0

    cleanup()
    timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
      if charIndex < suggestion.count {
        let index = suggestion.index(suggestion.startIndex, offsetBy: charIndex)
        displayedText.append(suggestion[index])
        charIndex += 1
      } else {
        timer.invalidate()
        self.isDeleting = true
        self.scheduleNextAnimation()
      }
    }
  }

  private func animateDeleting() {
    cleanup()
    timer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { timer in
      if !displayedText.isEmpty {
        displayedText.removeLast()
      } else {
        timer.invalidate()
        self.isDeleting = false
        self.currentSuggestionIndex = (self.currentSuggestionIndex + 1) % self.suggestions.count
        self.scheduleNextAnimation()
      }
    }
  }
}
