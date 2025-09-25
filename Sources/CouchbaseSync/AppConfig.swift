//
//  AppConfig.swift
//  CouchbaseSync
//
//  Created by Mark Powell on 8/15/25.
//

import CouchbaseLiteSwift

/// Store the Capella app details to use when instantiating the app and start authentication
public struct AppConfig {
    public static let shared = Self.loadAppConfig()
    public var endpointUrl: String
    public var capellaUrl: String
    public var couchbaseUser: String?
    public var couchbasePass: String?
    
    /// Read the atlasConfig.plist file and store the app ID and baseUrl to use elsewhere.
    public static func loadAppConfig() -> AppConfig {
        guard let path = Bundle.main.path(forResource: "capellaConfig", ofType: "plist") else {
            fatalError("Could not load capellaConfig.plist file!")
        }
        
        // Any errors here indicate that the capellaConfig.plist file has not been formatted properly.
        // Expected key/values:
        //      "endpointUrl": "your App Services URL"
        let data = NSData(contentsOfFile: path)! as Data
        let capellaConfigPropertyList = try! PropertyListSerialization.propertyList(from: data, format: nil) as! [String: Any]
        let endpointUrl = capellaConfigPropertyList["endpointUrl"]! as! String
        let capellaUrl = capellaConfigPropertyList["capellaUrl"]! as! String
        let login = capellaConfigPropertyList["couchbaseuser"] as? String ?? ""
        let pass = capellaConfigPropertyList["couchbasepass"] as? String ?? ""
        return AppConfig(
            endpointUrl: endpointUrl,
            capellaUrl: capellaUrl,
            couchbaseUser: login,
            couchbasePass: pass
        )
    }
    
    private init(
        endpointUrl: String,
        capellaUrl: String,
        couchbaseUser: String? = nil,
        couchbasePass: String? = nil
    ) {
        self.endpointUrl = endpointUrl
        self.capellaUrl = capellaUrl
        self.couchbaseUser = couchbaseUser
        self.couchbasePass = couchbasePass
    }
}


