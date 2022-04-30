//
//  DeleteAlertViewController.swift
//  Memo
//
//  Created by 김민지 on 2022/04/30.
//  메모 삭제 화면

import Foundation
import SnapKit
import UIKit

final class DeleteAlertViewController: UIViewController {
    private lazy var presenter = DeleteAlertPresenter(viewController: self)

    /// 경고 창 뷰
    private lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20.0

        return view
    }()

    /// 경고 메시지 라벨
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = """
                    정말 삭제하시겠습니까?
                    (삭제 후 내용을 복원할 수 없습니다)
                    """
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    /// 취소 버튼
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.addTarget(self, action: #selector(didTappedCancelButton), for: .touchUpInside)

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

// MARK: - DismissAlertProtocol Function
extension DeleteAlertViewController: DeleteAlertProtocol {
    /// 뷰 구성
    func setupView() {
        view.backgroundColor = .black.withAlphaComponent(0.5)

        let buttonStackView = UIStackView(arrangedSubviews: [cancelButton, deleteButton])
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually

        let alertStackView = UIStackView(arrangedSubviews: [messageLabel, buttonStackView])
        alertStackView.axis = .vertical
        alertStackView.alignment = .fill
        alertStackView.distribution = .fill

        view.addSubview(alertView)

        alertView.addSubview(alertStackView)

        alertView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(250.0)
            $0.height.equalTo(150.0)
        }

        alertStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10.0)
        }
    }

    /// 폰트 적용
    func applyFont() {
        let font = FontManager.getFont()

        messageLabel.font = font.largeFont
        cancelButton.titleLabel?.font = font.largeFont
        deleteButton.titleLabel?.font = font.largeFont
    }

    /// 화면 닫기
    func dismiss() {
        dismiss(animated: false)
    }
}

// MARK: - @objc Function
extension DeleteAlertViewController {
    /// 취소 버튼 클릭
    @objc func didTappedCancelButton() {
        presenter.didTappedCancelButton()
    }

    /// 삭제 버튼 클릭
    @objc func didTappedDeleteButton() {
        presenter.didTappedDeleteButton()
    }
}
