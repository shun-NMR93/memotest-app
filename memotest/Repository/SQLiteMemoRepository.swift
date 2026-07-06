//
//  SQLiteMemoRepository.swift
//  memotest
//
//  Created by nomushun on 2026/07/02.
//
import Foundation
import SQLite3

class SQLiteMemoRepository: MemoRepositoryProtocol {
    
    func save(_ memo: Memo) {
        
        let sql = """
        INSERT INTO memo (
            id,
            title,
            body,
            createdAt,
            updatedAt
        )
        VALUES (?, ?, ?, ?, ?)
        """
        
        let bindings: [Any] = [
            memo.id.uuidString,
            memo.title,
            memo.body,
            memo.createdAt.timeIntervalSince1970,
            memo.updatedAt.timeIntervalSince1970
        ]
        
        DatabaseManager.shared.executeSQL(sql, bindings: bindings)
        
    }
    
    func load(id: UUID) -> Memo? {
        
        let sql = """
        SELECT * FROM memo WHERE id = ?
        """
        
        var result: Memo?
        
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(DatabaseManager.shared.db, sql, -1, &statement, nil) == SQLITE_OK else {
            print("prepare error")
            return nil
        }
        
        sqlite3_bind_text(statement, 1, id.uuidString, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))

        if sqlite3_step(statement) == SQLITE_ROW {
            
            guard let idCString = sqlite3_column_text(statement, 0),
                  let titleCString = sqlite3_column_text(statement, 1),
                  let bodyCString = sqlite3_column_text(statement, 2) else {
                sqlite3_finalize(statement)
                return nil
            }
            
            let idString = String(cString: idCString)
            let title = String(cString: titleCString)
            let body = String(cString: bodyCString)
            
            let createdAt = Date(timeIntervalSince1970: sqlite3_column_double(statement, 3))
            let updatedAt = Date(timeIntervalSince1970: sqlite3_column_double(statement, 4))
            
            guard let uuid = UUID(uuidString: idString) else {
                sqlite3_finalize(statement)
                return nil
            }
            
            result = Memo(
                id: uuid,
                title: title,
                body: body,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
        }
        
        sqlite3_finalize(statement)
        return result
    }
    
    func loadAll() -> [Memo] {
        
        let sql = """
        SELECT * FROM memo
        """
        
        var memos: [Memo] = []
        
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(DatabaseManager.shared.db, sql, -1, &statement, nil) == SQLITE_OK else {
            print("prepare error")
            return []
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            
            guard let idCString = sqlite3_column_text(statement, 0),
                  let titleCString = sqlite3_column_text(statement, 1),
                  let bodyCString = sqlite3_column_text(statement, 2) else {
                continue
            }
            
            let idString = String(cString: idCString)
            let title = String(cString: titleCString)
            let body = String(cString: bodyCString)
            
            let createdAt = Date(timeIntervalSince1970: sqlite3_column_double(statement, 3))
            let updatedAt = Date(timeIntervalSince1970: sqlite3_column_double(statement, 4))
            
            guard let uuid = UUID(uuidString: idString) else {
                continue
            }
            
            let memo = Memo(
                id: uuid,
                title: title,
                body: body,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
            
            memos.append(memo)
        }
        
        sqlite3_finalize(statement)
        
        return memos
    }
        
        
    func delete(_ id: UUID) {
        
        let sql = """
        DELETE FROM memo WHERE id = ?
        """
        
        let bindings: [Any] = [
            id.uuidString
        ]
        
        DatabaseManager.shared.executeSQL(sql, bindings: bindings)
        
    }
    
    func update(_ memo: Memo) {
        
        let sql = """
            UPDATE memo
            SET
                title = ?,
                body = ?,
                updatedAt = ?
            WHERE id = ?
            """
        
        let bindings: [Any] = [
            memo.title,
            memo.body,
            memo.updatedAt.timeIntervalSince1970,
            memo.id.uuidString
        ]
        
        DatabaseManager.shared.executeSQL(sql, bindings: bindings)
    }
}
