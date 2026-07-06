//
//  MemoView.swift
//  memotest
//
//  Created by nomushun on 2026/07/06.
//
import Foundation

import SwiftUI

struct MemoView: View {

    private let store = MemoStore()

    @State private var title: String = ""
    @State private var memoBody: String = ""

    @State private var memos: [Memo] = []
    @State private var editingMemo: Memo? = nil

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    private func formatDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }

    var body: some View {
        NavigationStack {

            VStack(spacing: 16) {

                Text("Memo Test")
                    .font(.largeTitle)
                    .padding()

                HStack {
                    Button("キャンセル") {
                        editingMemo = nil
                        title = ""
                        memoBody = ""
                    }
                    .disabled(editingMemo == nil)
                    Spacer()
                }

                // 入力エリア
                TextField("タイトル", text: $title)
                    .textFieldStyle(.roundedBorder)

                TextField("本文", text: $memoBody)
                    .textFieldStyle(.roundedBorder)

                // 保存ボタン
                Button("保存") {

                    if let editingMemo = editingMemo {
                        // 更新
                        var updatedMemo = editingMemo
                        updatedMemo.title = title
                        updatedMemo.body = memoBody
                        updatedMemo.updatedAt = Date()
                        store.update(updatedMemo)
                    } else {
                        // 新規作成
                        let memo = Memo(
                            id: UUID(),
                            title: title,
                            body: memoBody,
                            createdAt: Date(),
                            updatedAt: Date()
                        )
                        store.save(memo)
                    }

                    // 再読み込み
                    memos = store.loadAll()

                    // 初期化
                    editingMemo = nil
                    title = ""
                    memoBody = ""
                }
                .buttonStyle(.borderedProminent)

                Divider()

                // 一覧
                List {

                    ForEach(memos, id: \.id) { memo in

                        NavigationLink(destination: MemoDetailView(memoId: memo.id)) {
                            VStack(alignment: .leading, spacing: 4) {

                                Text(memo.title)
                                    .font(.headline)

                                Text(memo.body)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                HStack {
                                    Text("作成: \(formatDate(memo.createdAt))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("更新: \(formatDate(memo.updatedAt))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in

                        indexSet.forEach { index in
                            let memo = memos[index]
                            store.delete(memo.id)
                        }

                        memos = store.loadAll()
                    }
                }
            }
            .padding()
            .navigationTitle("Memo Test")

            .onAppear {
                print("MemoView onAppear")
                memos = store.loadAll()
                print("Loaded \(memos.count) memos")
            }
        }
    }
}
