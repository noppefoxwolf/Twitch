import Foundation
import Combine

public enum Twitch {
    static let baseURL: URL = URL(string: "https://api.twitch.tv")!
    
    public struct Client {
        let clientID: String
        let accessToken: String
        
        public init(clientID: String, accessToken: String) {
            self.clientID = clientID
            self.accessToken = accessToken
        }
        
        func get<T: Codable>(path: String, queryItems: [URLQueryItem] = []) -> AnyPublisher<T, Error> {
            let endpoint = Twitch.baseURL.appendingPathComponent(path)
            var urlComponents = URLComponents(url: endpoint, resolvingAgainstBaseURL: false)!
            urlComponents.queryItems = queryItems
            var request = URLRequest(url: urlComponents.url!)
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.setValue(clientID, forHTTPHeaderField: "client-id")
            let session = URLSession(configuration: .default)
            return session.dataTaskPublisher(for: request).tryMap { (data, response) -> T in
                print(String.init(data: data, encoding: .utf8))
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    return try decoder.decode(T.self, from: data)
                } catch let (error) {
                    if let twitchError = try? decoder.decode(TwitchError.self, from: data) {
                        throw twitchError
                    } else {
                        throw error
                    }
                }
            }.receive(on: DispatchQueue.main).eraseToAnyPublisher()
        }
    }
}
