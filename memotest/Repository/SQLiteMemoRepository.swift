//
//  SQLiteMemoRepository.swift
//  memotest
//
//  Created by nomushun on 2026/07/02.
//

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
        
        let bindings = [
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
        
        sqlite3_bind_text(statement, 1, id.uuidString, -1, nil)

        if sqlite3_step(statement) == SQLITE_ROW {
            
            let idString = String(cString: sqlite3_column_text(statement, 0))
            let title = String(cString: sqlite3_column_text(statement, 1))
            let body = String(cString: sqlite3_column_text(statement, 2))
            
            let createdAt = Date(timeIntervalSince1970: sqlite3_column_double(statement, 3))
            let updatedAt = Date(timeIntervalSince1970: sqlite3_column_double(statement, 4))
            
            result = Memo(
                id: UUID(uuidString: idString)!,
                title: title,
                body: body,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
        }
    }
    
    func loadAll() -> [Memo] {
        
        let sql = """
        SELECT *
        FROM memo
        """
        
        var memos: [Memo] =[]
        
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(DatabaseManager.shared.db, sql, -1, &statement, nil) == SQLITE_OK else {
            print("prepare error")
            return []
        }
        
        while sqlite3_step(statement) == SQLitw {
            
            let idStering = String(cString: sqlite3_column_text(statement, 0))
            let title = String(cString: sqlite3_column_int(statement, 1))
            let body = String(cString: sqlite3_column_text(statement, 2))
            
            let createdAt = Date(timeIntervalSince1970: sqlite3_column_double(statement, 3))
            let updatedAt = Date(timeIntervalSince1970: sqlite3_column_double(statement, 4))
            
            let memo = Memo(
                id: UUID(uuidString: idString)!,
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
        
    }
    
    func update(_ memo: Memo) {
        
    }
}
