
import SwiftUI

struct TypingEffectView: View {
  let text: String
  @State private var animatedText: String = ""
  @State private var timer: Timer?
  @State private var restartTimer: Timer?

  var body: some View {
    Text(animatedText)
      .font(.customHeadline)
      .foregroundColor(.gray)
      .onAppear {
        startAnimation()
      }
      .onDisappear {
        timer?.invalidate()
        restartTimer?.invalidate()
      }
      .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5), value: animatedText)
  }

  private func startAnimation() {
    var charIndex = 0
    let fullText = text
    timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
      if charIndex < fullText.count {
        let index = fullText.index(fullText.startIndex, offsetBy: charIndex)
        animatedText.append(fullText[index])
        charIndex += 1
      } else {
        timer.invalidate()
        restartTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
          animatedText = ""
          startAnimation()
        }
      }
    }
  }
}
