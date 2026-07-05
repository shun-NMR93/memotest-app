//
//  DatabaseManager.swift
//  memotest
//
//  Created by nomushun on 2026/07/02.
//

import SQLite3

let SQLITE_TRANSIENT = unsafeBitCast(
    -1,
    to: sqlite3_destructor_type.self
)

final class DatabaseManager {
    
    static let shared = DatabaseManager()

    private(set) var db: OpaquePointer?
    
    private init() {
        openDatabase()
        createTable()
    }
    
    private func createTable() {
        let sql = """
        CREATE TABLE IF NOT EXISTS memo (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            body TEXT NOT NULL,
            createdAt REAL NOT NULL,
            updatedAt REAL NOT NULL
        )
        """

        executeSQL(sql, bindings: [])
    }
    
    private func openDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("memotest.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("DB open failed")
        } else {
            print("DB opened")
        }
    }
    
    func executeSQL(_ sql: String, bindings: [Any]) {
        
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else {
            print("prepare error")
            return
        }
        
        for (index, value) in bindings.enumerated() {
            
            let position = Int32(index + 1)
            
            if let v = value as? String {
                sqlite3_bind_text(statement, position, v, -1, SQLITE_TRANSIENT)
            } else if let v = value as? Double {
                sqlite3_bind_double(statement, position, v)
            } else if let v = value as? Int {
                sqlite3_bind_int(statement, position, Int32(v))
            }
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
                print("execution error")
        }
        
        sqlite3_finalize(statement)
    }
}
