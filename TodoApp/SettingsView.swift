import SwiftUI

let languageOptions = [
  ("Indonesia", "🇮🇩"),
  ("English", "🇺🇸"),
  ("Japanese", "🇯🇵"),
]

struct SettingsView: View {
  init() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(Color.black)
    let titleFont = UIFont.monospacedSystemFont(ofSize: 34, weight: .bold)
    let smallTitleFont = UIFont.monospacedSystemFont(ofSize: 17, weight: .bold)
    appearance.largeTitleTextAttributes = [.font: titleFont, .foregroundColor: UIColor.white]
    appearance.titleTextAttributes = [.font: smallTitleFont, .foregroundColor: UIColor.white]

    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
  }

  @State private var showingLanguageSheet = false
  @State private var selectedLanguage = "English"

  private var selectedLanguageFlag: String {
    (languageOptions.first(where: { $0.0 == selectedLanguage })?.1 ?? "🇺🇸")
  }

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("General").font(.customHeadline)) {
          Button(action: {
            showingLanguageSheet.toggle()
          }) {
            HStack {
              Image(systemName: "globe")
              Text("Language").font(.customBody)
              Spacer()
              Text(selectedLanguageFlag)
                .font(.customBody)
            }
          }
          .foregroundColor(.primary)
        }

        Section(header: Text("About").font(.customHeadline)) {
          HStack {
            Image(systemName: "info.circle")
            Text("Version").font(.customBody)
            Spacer()
            Text("1.0.0").font(.customBody)
          }
        }
      }
      .navigationTitle("Settings")
      .sheet(isPresented: $showingLanguageSheet) {
        NavigationView {
          LanguageSelectionView(selectedLanguage: $selectedLanguage, isPresented: $showingLanguageSheet)
        }
        .presentationDetents([.height(200)])
        .darkTheme()
      }
    }
    .darkTheme()
  }
}

struct LanguageSelectionView: View {
  @Binding var selectedLanguage: String
  @Binding var isPresented: Bool

  var body: some View {
    Form {
      ForEach(languageOptions, id: \.0) { language, flag in
        Button(action: {
          withAnimation(.spring) {
            self.selectedLanguage = language
            self.isPresented = false
          }
        }) {
          HStack {
            Text(flag)
            Text(language).font(.customBody)
            Spacer()
            if self.selectedLanguage == language {
              Image(systemName: "checkmark")
                .foregroundColor(.accentColor)
            }
          }
        }
        .foregroundColor(.primary)
      }
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
      .darkTheme()
  }
}
