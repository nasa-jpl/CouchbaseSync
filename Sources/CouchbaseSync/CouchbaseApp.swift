//
//  CBLApp.swift
//  SpaceImages-iOS
//
//  Created by Mark Powell on 8/1/25.
//

import CouchbaseLiteSwift
import Foundation

@Observable
public class CouchbaseApp {
    
    public var currentUser: User? = nil
    
    public var appConfig: AppConfig
    public var error: Error? = nil
    public var databaseState: DatabaseState = .notInitialized
    
    public init(configuration: AppConfig){
        appConfig = configuration
    }
    
    public func setCurrentUser(_ user: User?){
        self.currentUser = user
    }
    
    public func setError(_ error: Error?){
        self.error = error
    }
    
    public func setDatabaseState(_ state: DatabaseState){
        self.databaseState = state
    }
}

public struct User {
    public var username: String = ""
    public var password: String = ""
}

public struct ConnectionException: Error {
    public let message: String
}

public struct InvalidCredentialsException: Error {
    public let message: String
}

public struct ApplicationUserIsNil: Error {
    public let message: String
}

public struct InvalidEndpointUrl: Error {
    public let message: String
}

public struct InvalidStateError: Error {
    public let message: String
}
