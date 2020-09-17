//
//  Twitch+User.swift
//  Twitch
//
//  Created by Tomoya Hirano on 2020/09/14.
//

import Foundation
import Combine

public extension Twitch.Client {
    func getStreamKey(broadcasterID: String) -> AnyPublisher<GetMe.Response, Error> {
        self.get(path: "/helix/streams/key", params: ["broadcaster_id" : broadcasterID])
    }
    
    enum GetStreamKey {
        public struct Response: Codable {
            public let data: [StreamKey]
        }
    }
}
