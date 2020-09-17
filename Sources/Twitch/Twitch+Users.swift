//
//  Twitch+User.swift
//  Twitch
//
//  Created by Tomoya Hirano on 2020/09/14.
//

import Foundation
import Combine

public extension Twitch.Client {
    func getMe() -> AnyPublisher<GetMe.Response, Error> {
        self.get(path: "/helix/users")
    }
    
    enum GetMe {
        public struct Response: Codable {
            public let data: [User]
        }
    }
}
