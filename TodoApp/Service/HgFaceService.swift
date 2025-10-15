import Combine
import Foundation
import OSLog
import SwiftUI

// IMPORTANT: For demonstration purposes, the API key is hardcoded here.
// In a real application, you should use a secure method to store and access your API key,
// such as using a configuration file that is not checked into version control,
// or using a service like a secret manager.
private let apiKey = "YOUR_HUGGING_FACE_API_KEY" // Replace with your actual key

// MARK: - Hugging Face API Structures

struct HFRequest: Codable {
  let messages: [HFMessage]
  let model: String
  let stream: Bool
}

struct HFMessage: Codable {
  let role: String
  let content: String
}

// Represents a single chunk in the streaming response
struct HFStreamResponseChunk: Codable {
  let choices: [HFStreamChoice]?
}

struct HFStreamChoice: Codable {
  let delta: HFStreamDelta
}

struct HFStreamDelta: Codable {
  let content: String?
}

@MainActor
class HgFaceService: ObservableObject {
  @Published var generatedDescription: String = ""
  @Published var isGenerating: Bool = false
  @Published var errorMessage: String?
  private let logger = Logger(subsystem: "com.example.TodoApp", category: "GenerativeAIService")

  func generateDescription(for title: String) {
    isGenerating = true
    errorMessage = nil
    generatedDescription = "" // Clear previous content

    Task {
      do {
        try await performStreamingHuggingFaceRequest(with: title)
      } catch {
        self.errorMessage = error.localizedDescription
        logger.error("Error during streaming request: \(error.localizedDescription)")
      }
      isGenerating = false
    }
  }

  private func performStreamingHuggingFaceRequest(with title: String) async throws {
    guard let url = URL(string: "https://router.huggingface.co/v1/chat/completions") else {
      logger.error("Invalid Hugging Face API URL.")
      throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let prompt = "Buatlath deskripsi yang related dengan todo title ini: \(title) buat hanya dalam 3 baris saja jangan lebih ya, dan tambahkan emoticon yang sesuai dengan konteks yg dbuat"
    let requestBody = HFRequest(
      messages: [HFMessage(role: "user", content: prompt)],
      model: "zai-org/GLM-4.6:novita",
      stream: true // Enable streaming
    )

    request.httpBody = try JSONEncoder().encode(requestBody)

    let (bytes, response) = try await URLSession.shared.bytes(for: request)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
      logger.error("Hugging Face API request failed with HTTP status code \(statusCode).")
      throw NSError(domain: "HuggingFaceAPI", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Request failed."])
    }

    logger.info("Beginning to stream Hugging Face response.")
    for try await line in bytes.lines {
      if line.hasPrefix("data: ") {
        let jsonString = String(line.dropFirst(6))
        if jsonString == "[DONE]" {
          logger.info("Finished streaming Hugging Face response.")
          return
        }

        guard let jsonData = jsonString.data(using: .utf8) else { continue }

        do {
          let chunk = try JSONDecoder().decode(HFStreamResponseChunk.self, from: jsonData)
          if let text = chunk.choices?.first?.delta.content {
            logger.info("\(text)")
            // Append the new text to the published property on the main thread
            withAnimation(.spring()) {
              generatedDescription += text
            }
          }
        } catch {
          logger.warning("Failed to decode stream chunk: \(error.localizedDescription), chunk: \(jsonString)")
        }
      }
    }
  }
}
