//
//  ListPopupPresenter.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  메모 목록 화면 팝업 메뉴 Presenter

import Foundation

protocol ListPopupProtocol: AnyObject {
    func setupView()
}

final class ListPopupPresenter: NSObject {
    private let viewController: ListPopupProtocol?

    init(viewController: ListPopupProtocol?) {
        self.viewController = viewController
    }

    func viewDidLoad() {
        viewController?.setupView()
    }
}
