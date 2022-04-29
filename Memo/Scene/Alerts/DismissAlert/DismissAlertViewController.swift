//
//  WriteCancelAlertViewController.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  메모 작성 취소 경고창

import Foundation
import SnapKit
import UIKit

final class DismissAlertViewController: UIViewController {
    private lazy var presenter = DismissAlertPresenter(viewController: self)

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
                    작성 중인 내용이 있습니다.
                    정말 나갈까요?
                    """
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    /// 아니요 버튼
    private lazy var noButton: UIButton = {
        let button = UIButton()
        button.setTitle("아니요", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.addTarget(self, action: #selector(didTappedNoButton), for: .touchUpInside)

        return button
    }()

    /// 네 버튼
    private lazy var yesButton: UIButton = {
        let button = UIButton()
        button.setTitle("네", for: .normal)
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.addTarget(self, action: #selector(didTappedYesButton), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }
}

// MARK: - DismissAlertProtocol Function
extension DismissAlertViewController: DismissAlertProtocol {
    /// 뷰 구성
    func setupView() {
        view.backgroundColor = .black.withAlphaComponent(0.5)

        let buttonStackView = UIStackView(arrangedSubviews: [noButton, yesButton])
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
        noButton.titleLabel?.font = font.largeFont
        yesButton.titleLabel?.font = font.largeFont
    }

    /// 화면 닫기
    func dismiss() {
        dismiss(animated: false)
    }

    /// pop 노티 보내기
    func postPopNoti() {
        NotificationCenter.default.post(
            name: NSNotification.Name("PopWriteViewController"),
            object: nil
        )
    }
}

// MARK: - @objc Function
extension DismissAlertViewController {
    /// 아니요 버튼 클릭
    @objc func didTappedNoButton() {
        presenter.didTappedNoButton()
    }

    /// 네 버튼 클릭
    @objc func didTappedYesButton() {
        presenter.didTappedYesButton()
    }
}
