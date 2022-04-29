//
//  UserDefaultsManager.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  UserDefaults 관리자

import Foundation

protocol UserDefaultsManagerProtol {
    func getMemos() -> [Memo]
    func setMemo(_ newValue: Memo)
    func getMemoId() -> Int
    func setMemoId()
}

final class UserDefaultsManager: UserDefaultsManagerProtol {
    enum Key: String {
        case memo   // 메모
        case memoId // 메모 아이디
    }

    /// 메모 가져오기
    func getMemos() -> [Memo] {
        guard let data = UserDefaults.standard.data(forKey: Key.memo.rawValue) else { return [] }
        return (try? PropertyListDecoder().decode([Memo].self, from: data)) ?? []
    }

    /// 메모 저장하기
    func setMemo(_ newValue: Memo) {
        var currentMemos: [Memo] = getMemos()
        currentMemos.insert(newValue, at: 0)
        UserDefaults.standard.setValue(try? PropertyListEncoder().encode(currentMemos), forKey: Key.memo.rawValue)
    }

    /// 메모 아이디 가져오기
    func getMemoId() -> Int {
        return UserDefaults.standard.integer(forKey: Key.memoId.rawValue)
    }

    /// 메모 아이디 저장하기
    func setMemoId() {
        let currentMemoId: Int = getMemoId()
        UserDefaults.standard.set(currentMemoId + 1, forKey: Key.memoId.rawValue)
    }
}
