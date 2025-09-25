//
//  CollectionConfiguration.swift
//  CouchbaseSync
//
//  Created by Mark Powell on 8/15/25.
//

import CouchbaseLiteSwift
import Foundation

public struct CollectionConfiguration {
    public let name: String
    public let scope: String
    public let createIndices: ((Collection)->Void)?
    
    public init(
        name: String,
        scope: String,
        createIndices: ((Collection)->Void)? = nil
    ) {
        self.name = name
        self.scope = scope
        self.createIndices = createIndices
    }
}
