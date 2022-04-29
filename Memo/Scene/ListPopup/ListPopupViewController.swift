//
//  ListPopupViewController.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  메모 목록 화면 팝업 메뉴(검색, 설정)

import Foundation
import SnapKit
import UIKit

final class ListPopupViewController: UIViewController {
    private lazy var presenter = ListPopupPresenter(viewController: self)

    /// 검색 버튼
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("검색", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.addTarget(self, action: #selector(didTappedSearchButton), for: .touchUpInside)

        return button
    }()

    /// 설정 버튼
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setTitle("설정", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.addTarget(self, action: #selector(didTappedSettingsButton), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }
}

// MARK: - ListPopupProtocol Function
extension ListPopupViewController: ListPopupProtocol {
    /// 뷰 구성
    func setupView() {
        view.backgroundColor = .systemBackground

        let stackView = UIStackView(arrangedSubviews: [searchButton, settingsButton])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually

        view.addSubview(stackView)

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    /// 폰트 적용
    func applyFont() {
        let font = FontManager.getFont()

        searchButton.titleLabel?.font = font.largeFont
        settingsButton.titleLabel?.font = font.largeFont
    }
}

// MARK: - @objc Function
extension ListPopupViewController {
    @objc func didTappedSearchButton() {}

    @objc func didTappedSettingsButton() {}
}
