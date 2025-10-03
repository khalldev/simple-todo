//
//  LinksView.swift
//  TodoApp
//
//  Created by Khal on 3/10/25.
//

import LinkPresentation
import SafariServices
import SwiftUI

struct LinkPreview: UIViewRepresentable {
  var url: URL

  func makeUIView(context _: Context) -> LPLinkView {
    let linkView = LPLinkView(url: url)
    let provider = LPMetadataProvider()

    provider.startFetchingMetadata(for: url) { metadata, _ in
      if let metadata = metadata {
        DispatchQueue.main.async {
          linkView.metadata = metadata
        }
      }
    }
    return linkView
  }

  func updateUIView(_: LPLinkView, context _: Context) {}
}

struct SafariView: UIViewControllerRepresentable {
  let url: URL

  func makeUIViewController(context _: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
    return SFSafariViewController(url: url)
  }

  func updateUIViewController(_: SFSafariViewController, context _: UIViewControllerRepresentableContext<SafariView>) {}
}

extension URL: Identifiable {
  public var id: String { absoluteString }
}

struct LinkItem: Identifiable {
  let id = UUID()
  let name: String
  let url: String
}

struct LinksView: View {
  @State private var selectedURL: URL?

  let links: [LinkItem] = [
    LinkItem(name: "Google", url: "https://www.google.com"),
    LinkItem(name: "Apple", url: "https://www.apple.com"),
    LinkItem(name: "Project GitHub", url: "https://github.com/khalldev/simple-todo"),
  ]

  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      NavigationView {
        ScrollView {
          VStack(spacing: 8) {
            ForEach(links) { link in
              Button(action: {
                selectedURL = URL(string: link.url)
              }) {
                VStack(alignment: .leading) {
                  HStack {
                    Text(link.name)
                      .font(.customBody)
                    Spacer()
                    Image(systemName: "link")
                      .foregroundColor(.terminalGreen)
                  }
                  .padding(.bottom, 12)

                  if let url = URL(string: link.url) {
                    LinkPreview(url: url)
                      .frame(height: 140)
                      .cornerRadius(8)
                      .clipped()
                  }
                }
                .onTapGesture {
                  selectedURL = URL(string: link.url)
                }
              }
              .padding()
              .glassEffect(in: .rect(cornerRadius: 16.0))
              .padding(.bottom, 24)
            }
          }
          .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .principal) {
            Text("Links")
              .font(.customHeadline)
              .foregroundColor(.white)
          }
        }
      }
      .darkTheme()
      .sheet(item: $selectedURL) { url in
        SafariView(url: url)
      }
    }
  }
}

#Preview {
  LinksView()
}
