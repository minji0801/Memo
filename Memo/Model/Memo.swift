//
//  Memo.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  메모 모델

import Foundation

struct Memo: Codable {
    let id: Int         // 아이디
    let content: String // 메모 내용
    var isSecret: Bool  // 비밀메모인지

    init(
        id: Int,
        content: String,
        isSecret: Bool
    ) {
        self.id = id
        self.content = content
        self.isSecret = isSecret
    }
}

extension Memo {
    static let EMPTY = Memo(id: -1, content: "", isSecret: false)
    static let TEST = Memo(id: 0, content: "테스트", isSecret: true)
}
