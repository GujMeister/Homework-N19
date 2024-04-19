import Foundation

// MARK: - ImediNewsModel
struct ImediNewsModel: Codable {
    let list: [List]?
    
    enum CodingKeys: String, CodingKey {
        case list = "List"
    }
}

// MARK: - List
struct List: Codable {
    let title, time: String?
    let url: String?
    let type: Int?
    let photoUrl: String?
    let photoAlt: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case time = "Time"
        case url = "Url"
        case type = "Type"
        case photoUrl = "PhotoUrl"
        case photoAlt = "PhotoAlt"
    }
}
