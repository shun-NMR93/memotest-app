//
//  MemoDetailView.swift
//  memotest
//
//  Created by nomushun on 2026/07/06.
//

import SwiftUI

struct MemoDetailView: View {
    
    let memoId: UUID
    private let store = MemoStore()
    
    @State private var memo: Memo?
    @State private var isEditing = false
    @State private var title: String = ""
    @State private var memoBody: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
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
                if let memo = memo {
                    if isEditing {
                        // 編集モード
                        VStack(spacing: 16) {
                            TextField("タイトル", text: $title)
                                .textFieldStyle(.roundedBorder)
                            
                            TextField("本文", text: $memoBody, axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                                .lineLimit(5...10)
                            
                            HStack {
                                Button("キャンセル") {
                                    isEditing = false
                                    title = memo.title
                                    memoBody = memo.body
                                }
                                .buttonStyle(.bordered)
                                
                                Spacer()
                                
                                Button("保存") {
                                    var updatedMemo = memo
                                    updatedMemo.title = title
                                    updatedMemo.body = memoBody
                                    updatedMemo.updatedAt = Date()
                                    store.update(updatedMemo)
                                    self.memo = updatedMemo
                                    isEditing = false
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                        .padding()
                    } else {
                        // 表示モード
                        VStack(alignment: .leading, spacing: 16) {
                            Text(memo.title)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Divider()
                            
                            Text(memo.body)
                                .font(.body)
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("作成日時: \(formatDate(memo.createdAt))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("更新日時: \(formatDate(memo.updatedAt))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            HStack {
                                Button("編集") {
                                    isEditing = true
                                    title = memo.title
                                    memoBody = memo.body
                                }
                                .buttonStyle(.borderedProminent)
                                
                                Spacer()
                                
                                Button("削除") {
                                    store.delete(memo.id)
                                    dismiss()
                                }
                                .buttonStyle(.bordered)
                                .foregroundColor(.red)
                            }
                        }
                        .padding()
                    }
                } else {
                    ProgressView("読み込み中...")
                }
            }
            .navigationTitle("メモ詳細")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("閉じる") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                memo = store.load(id: memoId)
                if let memo = memo {
                    title = memo.title
                    memoBody = memo.body
                }
            }
        }
    }
}
