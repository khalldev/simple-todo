import Combine
import Foundation
import OSLog
import SwiftUI

// IMPORTANT: For demonstration purposes, the API key is hardcoded here.
// In a real application, you should use a secure method to store and access your API key,
// such as using a configuration file that is not checked into version control,
// or using a service like a secret manager.
private let apiKey = "YOUR_HUGGING_FACE_API_KEY" // Replace with your actual key

// MARK: - Hugging Face API Request/Response Structures

struct HFRequest: Codable {
  let messages: [HFMessage]
  let model: String
  let stream: Bool = false
}

struct HFMessage: Codable {
  let role: String
  let content: String
}

struct HFResponse: Codable {
  let choices: [HFChoice]?
  let error: String?
}

struct HFChoice: Codable {
  let message: HFResponseMessage
}

struct HFResponseMessage: Codable {
  let content: String
}

@MainActor
class GeminiService: ObservableObject {
  @Published var generatedDescription: String = ""
  @Published var isGenerating: Bool = false
  @Published var errorMessage: String?
  private let logger = Logger(subsystem: "com.example.TodoApp", category: "GenerativeAIService")

  func generateDescription(for title: String) {
    isGenerating = true
    errorMessage = nil

    Task {
      do {
        let description = try await performHuggingFaceRequest(with: title)
        self.generatedDescription = description
      } catch {
        self.errorMessage = error.localizedDescription
      }
      isGenerating = false
    }
  }

  private func performHuggingFaceRequest(with title: String) async throws -> String {
    guard let url = URL(string: "https://router.huggingface.co/v1/chat/completions") else {
      logger.error("Invalid Hugging Face API URL.")
      throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let prompt = "Generate a short, one-sentence description for the following to-do item: \(title)"
    let requestBody = HFRequest(
      messages: [HFMessage(role: "user", content: prompt)],
      model: "zai-org/GLM-4.6:novita"
    )

    do {
      let encoder = JSONEncoder()
      request.httpBody = try encoder.encode(requestBody)
    } catch {
      logger.error("Failed to encode request body: \(error.localizedDescription)")
      throw error
    }

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      if let httpResponse = response as? HTTPURLResponse {
        let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
        logger.error("Hugging Face API request failed with HTTP status code \(httpResponse.statusCode). Body: \(responseBody)")
        throw NSError(domain: "HuggingFaceAPI", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Error: \(httpResponse.statusCode). Body: \(responseBody)"])
      } else {
        logger.error("Hugging Face API request failed: Not an HTTP response.")
        throw URLError(.badServerResponse)
      }
    }

    do {
      let decoder = JSONDecoder()
      let hfResponse = try decoder.decode(HFResponse.self, from: data)

      if let apiError = hfResponse.error {
        logger.error("Hugging Face API returned an error: \(apiError)")
        throw NSError(domain: "HuggingFaceAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: apiError])
      }

      guard let text = hfResponse.choices?.first?.message.content else {
        logger.error("Failed to find text in Hugging Face response.")
        throw NSError(domain: "HuggingFaceAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response."])
      }
      logger.info("Successfully received and parsed Hugging Face response.")
      return text.trimmingCharacters(in: .whitespacesAndNewlines)
    } catch {
      logger.error("Failed to decode Hugging Face response: \(error.localizedDescription)")
      throw error
    }
  }
}
