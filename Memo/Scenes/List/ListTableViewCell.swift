//
//  ListTableViewCell.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  메모 목록 화면 테이블 뷰 셀

import UIKit

final class ListTableViewCell: UITableViewCell {
    static let identifier = "ListTableViewCell"

    let testMemo = [
        "오늘은 치과를 다녀왔다. 크라운 치료를 받는데 너무 힘들었다.. 아직 아무것도 못먹었다..ㅠ",
        "비밀메모 입니다.",
        "먹킷리스트 육회, 햄버거, 뿌링클, 초밥, 스테이크"
    ]

    let testSecret = [false, true, false]

    func update(_ row: Int) {
        textLabel?.text = testMemo[row]
        if testSecret[row] {
            imageView?.image = UIImage(systemName: "lock.fill")
        }
    }
}

private extension ListTableViewCell {
    func setupView() {}
}
