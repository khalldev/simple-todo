
import SwiftUI

// MARK: - Fonts

extension Font {
  static let customTitle = Font.system(.largeTitle, design: .monospaced).weight(.bold)
  static let customHeadline = Font.system(.headline, design: .monospaced)
  static let customBody = Font.system(.body, design: .monospaced)
}

// MARK: - Colors

extension Color {
  static let terminalGreen = Color(red: 0.2, green: 0.8, blue: 0.2)
  static let darkPrimaryBackground = Color(red: 0.0, green: 0.1, blue: 0.05)
  static let darkSecondaryBackground = Color(red: 0.05, green: 0.2, blue: 0.1)
  static let darkPrimaryText = Color.white
  static let darkSecondaryText = Color.gray
}

// MARK: - UI Components & Effects

struct GlassEffect: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding()
      .background(
        .ultraThinMaterial.opacity(0.7)
      )
      .cornerRadius(15)
      .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
  }
}

struct DarkTheme: ViewModifier {
  func body(content: Content) -> some View {
    content
      .background(Color.darkPrimaryBackground.ignoresSafeArea())
      .foregroundColor(Color.darkPrimaryText)
      .accentColor(.terminalGreen)
      .colorScheme(.dark)
  }
}

extension View {
  func darkTheme() -> some View {
    modifier(DarkTheme())
  }
}
