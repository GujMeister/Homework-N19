import Foundation

func getImediData() async throws -> ImediNewsModel {
    let endpoint = "https://imedinews.ge/api/categorysidebarnews/get"
    
    guard let URL = URL(string: endpoint) else { throw Errors.invalidURL }
    print("Fetching weather data...")
    
    let (data, response) = try await URLSession.shared.data(from: URL)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw Errors.invalidResponse
    }
    print("Response received: \(response.statusCode)")
    
    do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let imediData = try decoder.decode(ImediNewsModel.self, from: data)
        print("Weather data decoded: \(imediData)")
        return imediData
    } catch {
        print("Error decoding data: \(error)")
        print(String(data: data, encoding: .utf8)!)
        throw Errors.invalidData
    }
}

enum Errors:Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
