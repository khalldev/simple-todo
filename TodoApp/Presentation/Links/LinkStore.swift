import Foundation
import SwiftData

@Model
final class LinkStore {
    var id: UUID
    var name: String
    var url: String
    var createdAt: Date

    init(id: UUID = UUID(), name: String, url: String, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.url = url
        self.createdAt = createdAt
    }
}
