//
//  MemoStore.swift
//  memotest
//
//  Created by nomushun on 2026/07/06.
//

final class MemoStore {

    private let repository: MemoRepositoryProtocol

    init(repository: MemoRepositoryProtocol = SQLiteMemoRepository()) {
        self.repository = repository
    }
}
