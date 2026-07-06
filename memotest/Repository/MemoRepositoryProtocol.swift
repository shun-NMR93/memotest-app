//
//  MemoRepositoryProtocol.swift
//  memotest
//
//  Created by nomushun on 2026/07/02.
//
import Foundation

protocol MemoRepositoryProtocol {
    func save(_ memo: Memo)
    func load(id: UUID) -> Memo?
    func loadAll() -> [Memo]
    func delete(_ id: UUID)
    func update(_ memo: Memo)
}
