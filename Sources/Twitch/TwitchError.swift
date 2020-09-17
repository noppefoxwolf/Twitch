//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2020/09/18.
//

import Foundation

public struct TwitchError: Error, Decodable {
    public let error: String
    public let status: Int
    public let message: String
}
