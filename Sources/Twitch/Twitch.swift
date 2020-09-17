import Foundation
import Combine

public enum Twitch {
    static let baseURL: URL = URL(string: "https://api.twitch.tv/")!
    
    public struct Client {
        let clientID: String
        let accessToken: String
        
        public init(clientID: String, accessToken: String) {
            self.clientID = clientID
            self.accessToken = accessToken
        }
        
        func get<T: Codable>(path: String, params: [String : String] = [:]) -> AnyPublisher<T, Error> {
            let query = params.map({ "\($0.key)=\($0.value)" }).joined(separator: "&")
            var url = Twitch.baseURL.appendingPathComponent(path)
            if !query.isEmpty {
                url.appendPathComponent("?" + query)
            }
            print(url)
            var request = URLRequest(url: url)
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.setValue(clientID, forHTTPHeaderField: "client-id")
            let session = URLSession(configuration: .default)
            return session.dataTaskPublisher(for: request).tryMap { (data, response) -> T in
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
