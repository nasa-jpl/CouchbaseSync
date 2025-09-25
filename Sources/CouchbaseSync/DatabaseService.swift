
//
//  DatabaseState.swift
//  SpaceImages-iOS
//
//  Created by Mark Powell on 8/1/25.
//


import Combine
import CouchbaseLiteSwift
import Foundation

public actor DatabaseService {
    
    public var app: CouchbaseApp
    public let databaseName: String

    //replicator management
    public var replicator: Replicator? = nil
    public var cancellables = Set<AnyCancellable>()

    //database information
    public var database: Database? = nil
    public var collections: [Collection] = []

    public init(app: CouchbaseApp, databaseName: String) {
        self.app = app
        self.databaseName = databaseName
        Database.log.console.level = .error
    }

    public func initializeDatabase(
        _ collectionConfigurations: [CollectionConfiguration],
        authenticator: Authenticator
    ) {
        do {
            app.setDatabaseState(.notInitialized)

            //open database
            self.database = try Database(name: databaseName)
            if let db = self.database {
                
                //get the collection - create collection with either create a collection
                //or if it already exist, return the existing collection
                collections.removeAll()
                for collectionConfig in collectionConfigurations {
                    let collection = try db.createCollection(name: collectionConfig.name, scope: collectionConfig.scope)
                    collections.append(collection)
                    
                    // create collection change publisher
                    collection.changePublisher()
                        .sink { change in print("Collection \(change.collection.name) changed.") }
                        .store(in: &cancellables)

                    // database index for query performance
                    // optional closure to add one or more to collection
                    collectionConfig.createIndices?(collection)
                }
          
                //setup replicator
                guard let targetUrl = URL(string: app.appConfig.endpointUrl) else {
                    app.error = InvalidEndpointUrl(message: "URL in capellaConfig is invalid")
                    print("\(app.error!)")
                    return
                }
                let targetEndpoint = URLEndpoint(url: targetUrl)

                //create replicator config
                var replConfig = ReplicatorConfiguration(target: targetEndpoint)
                replConfig.replicatorType = .pushAndPull
                replConfig.continuous = true

                //configure collections to sync
                for collection in collections {
                    replConfig.addCollection(collection)
                }

                //add authentication
                replConfig.authenticator = authenticator

                //create the replicator
                self.replicator = Replicator(config: replConfig)
                self.replicator?.changePublisher()
                    .sink { change in print("Replicator status changed: \(change)") }
                    .store(in: &cancellables)
                self.replicator?.documentReplicationPublisher()
                    .sink { change in
                        change.documents.forEach { document in
                            print("Document \(document.id) replicated.")
                        }
                    }
                    .store(in: &cancellables)
                self.replicator?.start()
            
                app.setDatabaseState(.open)
                
                #if DEBUG
                print("DatabaseService has \(cancellables.count) cancellables")

                for collection in collections {
                    print("Collection at open: \(collection.fullName)")
                    print("Collection count at open: \(collection.count)")
                }
                #endif
            }
        } catch let error {
            print("Error: \(error) \(error.localizedDescription)")
            app.setDatabaseState(.error(error))
        }
    }
    
    public func close() {
        do {
            self.cancellables.forEach { $0.cancel() }
            self.replicator?.stop()
            try self.database?.close()
        } catch {
            app.setError(error)
        }
    }

    public func pauseSync() {
        self.replicator?.stop()
    }

    public func resumeSync() {
        self.replicator?.start()
    }
}
