//
//  DatabaseState.swift
//  CouchbaseSync
//
//  Created by Mark Powell on 8/15/25.
//


public enum DatabaseState {
    //database is not initialized
    case notInitialized
    //Starting the Replicator Sync process
    case connecting
    //The database has been opened and is ready for use.
    case open
    //Opening the database or the replicator sync failed
    case error(Error)
}