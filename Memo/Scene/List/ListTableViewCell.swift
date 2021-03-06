//
//  ListTableViewCell.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  메모 목록 화면 테이블 뷰 셀

import UIKit

final class ListTableViewCell: UITableViewCell {
    static let identifier = "ListTableViewCell"

    func update(_ memo: Memo) {
        selectionStyle = .none

        let font = FontManager.getFont()
        textLabel?.font = font.mediumFont

        if memo.isSecret {
            imageView?.image = UIImage(systemName: "lock.fill")
            textLabel?.text = "비밀 메모입니다."
        } else {
            imageView?.image = nil
            textLabel?.text = memo.content
        }
    }
}
