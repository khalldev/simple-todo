//
//  LinksView.swift
//  TodoApp
//
//  Created by Khal on 3/10/25.
//

import LinkPresentation
import SafariServices
import SwiftUI
import UIKit

struct Shimmer: View {
  @State private var phase: CGFloat = 0
  var body: some View {
    Rectangle()
      .fill(Color.black.opacity(0.5))
      .overlay(
        Rectangle()
          .fill(Color.white.opacity(0.2))
          .mask(
            Rectangle()
              .fill(
                LinearGradient(gradient: .init(colors: [.clear, .white.opacity(0.2), .clear]), startPoint: .leading, endPoint: .trailing)
              )
              .rotationEffect(.degrees(70))
              .offset(x: phase * 200)
          )
      )
      .glassEffect(in: .rect(cornerRadius: 16.0))
      .onAppear {
        withAnimation(Animation.spring(duration: 1.5).repeatForever(autoreverses: false)) {
          phase = 1.0
        }
      }
  }
}

#Preview {
  Shimmer()
    .frame(height: 140)
    .cornerRadius(16)
    .padding()
}

struct LPLinkViewWrapper: UIViewRepresentable {
  var metadata: LPLinkMetadata

  func makeUIView(context _: Context) -> LPLinkView {
    let linkView = LPLinkView(metadata: metadata)
    return linkView
  }

  func updateUIView(_ uiView: LPLinkView, context _: Context) {
    uiView.metadata = metadata
  }
}

struct AsyncLinkPreview: View {
  let url: URL
  @State private var metadata: LPLinkMetadata?

  var body: some View {
    ZStack {
      if let metadata = metadata {
        LPLinkViewWrapper(metadata: metadata)
      } else {
        Shimmer()
      }
    }
    .onAppear(perform: fetchMetadata)
  }

  private func fetchMetadata() {
    let provider = LPMetadataProvider()
    provider.startFetchingMetadata(for: url) { metadata, _ in
      if let metadata = metadata {
        DispatchQueue.main.async {
          self.metadata = metadata
        }
      }
    }
  }
}

struct SafariView: UIViewControllerRepresentable {
  let url: URL

  func makeUIViewController(context _: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
    return SFSafariViewController(url: url)
  }

  func updateUIViewController(_: SFSafariViewController, context _: Context) {}
}

extension URL: Identifiable {
  public var id: String { absoluteString }
}

struct LinkItem: Identifiable {
  let id = UUID()
  let name: String
  let url: String
  let createdAt: Date
}

struct LinksView: View {
  @State private var selectedURL: URL?

  let links: [LinkItem] = [
    LinkItem(name: "Glass Effect", url: "https://developer.apple.com/documentation/SwiftUI/Applying-Liquid-Glass-to-custom-views", createdAt: Date()),
    LinkItem(name: "Google", url: "https://www.google.com", createdAt: Date()),
    LinkItem(name: "Apple", url: "https://www.apple.com", createdAt: Date().addingTimeInterval(-86400)),
  ]

  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      NavigationView {
        ScrollView {
          VStack(spacing: 8) {
            ForEach(links) { link in
              Button(action: {
                if let url = URL(string: link.url) {
                  selectedURL = url
                }
              }) {
                VStack(alignment: .leading, spacing: 12) {
                  HStack {
                    Text(link.name)
                      .font(.customBody)
                    Spacer()
                    Image(systemName: "link")
                      .foregroundColor(.terminalGreen)
                  }
                  .padding(.bottom, 18)

                  if let url = URL(string: link.url) {
                    AsyncLinkPreview(url: url)
                      .frame(height: 140)
                      .cornerRadius(16)
                      .clipped()
                  }

                  HStack {
                    Spacer()
                    Text(link.createdAt.formatted(.relative(presentation: .named)))
                      .font(.customBody)
                      .foregroundColor(.gray)
                  }
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
