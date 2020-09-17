//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2020/09/18.
//

import Foundation

public struct User: Identifiable, Hashable, Equatable, Codable {
    public let id: String
    public let displayName: String
}

public struct StreamKey: Codable {
    public let streamKey: String
}
