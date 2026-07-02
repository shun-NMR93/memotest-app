//
//  DatabaseManager.swift
//  memotest
//
//  Created by nomushun on 2026/07/02.
//

import SQLite3

final class DatabaseManager {
    
    static let shared = DatabaseManager()

    private var db: OpaquePointer?
    
    private init() {
        openDatabase()
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
                sqlite3_bind_text(statement, position, v, -1, nil)
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
