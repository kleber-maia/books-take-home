import Foundation

struct SearchItemModel: Codable {
    let key: String?
    let title: String?
    let subtitle: String?
    let editionCount: Int?
    let firstPublishYear: Int?
    let isbn: [String]?
    let publisher: [String]?
    let authorKey: [String]?
    let authorName: [String]?
    let subjectKey: [String]?
    let subject: [String]?
}
