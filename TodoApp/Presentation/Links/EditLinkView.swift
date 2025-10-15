import SwiftUI
import SwiftData

struct EditLinkView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var link: LinkStore

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $link.name)
                TextField("URL", text: $link.url)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
            }
            .navigationTitle("Edit Link")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
