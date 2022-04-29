//
//  PasswordAlertViewController.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  암호 입력 Alert 창

import Foundation
import SnapKit
import UIKit

final class PasswordAlertViewController: UIViewController {
    private lazy var presenter = PasswordAlertPresenter(viewController: self)

    /// Alert 창 뷰
    private lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20.0

        return view
    }()

    /// 메시지 라벨
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "메모를 잠그려면 암호를 입력해주세요."
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    /// 암호 입력 텍스트 필드
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "암호"
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.becomeFirstResponder()

        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.cornerRadius = 10.0

        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        textField.leftViewMode = .always

        textField.delegate = presenter

        return textField
    }()

    /// 취소 버튼
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.addTarget(self, action: #selector(didTappedCancelButton), for: .touchUpInside)

        return button
    }()

    /// 확인 버튼
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.addTarget(self, action: #selector(didTappedConfirmButton), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }
}

extension PasswordAlertViewController: PasswordAlertProtocol {
    /// 뷰 구성
    func setupView() {
        view.backgroundColor = .black.withAlphaComponent(0.5)

        let buttonStackView = UIStackView(arrangedSubviews: [cancelButton, confirmButton])
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually

        let alertStackView = UIStackView(arrangedSubviews: [messageLabel, passwordTextField, buttonStackView])
        alertStackView.axis = .vertical
        alertStackView.alignment = .fill
        alertStackView.distribution = .fill
        alertStackView.spacing = 10.0

        view.addSubview(alertView)

        alertView.addSubview(alertStackView)

        alertView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(200.0)
            $0.width.equalTo(250.0)
            $0.height.equalTo(150.0)
        }

        alertStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16.0)
        }

        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(30.0)
        }
    }

    /// 폰트 적용
    func applyFont() {
        let font = FontManager.getFont()

        messageLabel.font = font.largeFont
        passwordTextField.font = font.mediumFont
        cancelButton.titleLabel?.font = font.largeFont
        confirmButton.titleLabel?.font = font.largeFont
    }

    /// 화면 닫기
    func dismiss() {
        dismiss(animated: false)
    }

    /// 메시지 라벨 업데이트
    func updateMessageLabel() {
        messageLabel.text = "암호를 입력해주세요."
        messageLabel.textColor = .systemRed
    }
}

extension PasswordAlertViewController {
    /// 취소 버튼 클릭 -> 화면 닫기
    @objc func didTappedCancelButton() {
        presenter.didTappedCancelButton()
    }

    /// 확인 버튼 클릭 -> 암호 저장
    @objc func didTappedConfirmButton() {
        presenter.didTappedConfirmButton(passwordTextField.text)
    }
}
