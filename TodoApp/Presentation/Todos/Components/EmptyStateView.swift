import SwiftUI

struct EmptyStateView: View {
  let message: String

  var body: some View {
    VStack {
      Spacer()
      Text(message)
        .font(.customBody)
        .multilineTextAlignment(.center)
        .foregroundStyle(.white)
        .padding(.horizontal, 32)
      Spacer()
    }
  }
}

#Preview {
  EmptyStateView(message: "This is a sample empty state message.")
    .background(Color.black)
}
