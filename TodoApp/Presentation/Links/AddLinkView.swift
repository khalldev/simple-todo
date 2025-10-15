import SwiftUI
import SwiftData

fileprivate struct GlassTitledTextField: View {
    var title: String
    @Binding var text: String
    
    var body: some View {
        HStack(alignment: .center) {
            TextField(title, text: $text, axis: .vertical)
                .lineLimit(1 ... 8)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .font(.customBody)
        .glassEffect(in: .rect(cornerRadius: 16))
    }
}

struct AddLinkView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var url: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                GlassTitledTextField(title: "Name", text: $name)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()

                GlassTitledTextField(title: "URL", text: $url)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Link")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        addLink()
                        dismiss()
                    }
                    .disabled(name.isEmpty || url.isEmpty || !isValidURL(urlString: url))
                }
            }
        }
    }

    private func addLink() {
        let newLink = LinkStore(name: name, url: url)
        modelContext.insert(newLink)
    }
    
    private func isValidURL(urlString: String) -> Bool {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            return true
        }
        return false
    }
}