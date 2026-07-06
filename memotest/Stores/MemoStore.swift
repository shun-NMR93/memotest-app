//
//  MemoStore.swift
//  memotest
//
//  Created by nomushun on 2026/07/06.
//
import Foundation

final class MemoStore {

    private let repository: MemoRepositoryProtocol

    init(repository: MemoRepositoryProtocol = SQLiteMemoRepository()) {
        self.repository = repository
    }
    
    func save(_ memo: Memo) {
        repository.save(memo)
    }
    
    func load(id: UUID) -> Memo? {
        return repository.load(id: id)
    }
    
    func loadAll() -> [Memo] {
        return repository.loadAll()
    }
    
    func delete(_ id: UUID) {
        repository.delete(id)
    }
    
    func update(_ memo: Memo) {
        repository.update(memo)
    }
}
