//
//  DetailPopupViewController.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  메모 상세 화면 팝업 메뉴(수정, 삭제)

import Foundation
import SnapKit
import UIKit

final class DetailPopupViewController: UIViewController {
    private lazy var presenter = DetailPopupPresenter(viewController: self)

    /// 수정 버튼
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.addTarget(self, action: #selector(didTappedEditButton), for: .touchUpInside)

        return button
    }()

    /// 삭제 버튼
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.addTarget(self, action: #selector(didTappedDeleteButton), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }
}

// MARK: - ListPopupProtocol Function
extension DetailPopupViewController: DetailPopupProtocol {
    /// 뷰 구성
    func setupView() {
        view.backgroundColor = .systemBackground

        let stackView = UIStackView(arrangedSubviews: [editButton, deleteButton])
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

        editButton.titleLabel?.font = font.largeFont
        deleteButton.titleLabel?.font = font.largeFont
    }

    /// 화면 닫기
    func dismiss() {
        dismiss(animated: true)
    }
}

// MARK: - @objc Function
extension DetailPopupViewController {
    @objc func didTappedEditButton() {
        presenter.didTappedEditButton()
    }

    @objc func didTappedDeleteButton() {
        presenter.didTappedDeleteButton()
    }
}
