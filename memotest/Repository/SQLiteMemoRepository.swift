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
        
        DatabaseManager.execute(sql, bindings: bindings)
        
    }
    func load(id: UUID) -> Memo? {
        
    }
    func loadAll() -> [Memo] {
        
    }
    func delete(_ id: UUID) {
        
    }
    func update(_ memo: Memo) {
        
    }
}
