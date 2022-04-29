//
//  SaveAlertViewController.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  작성한 메모 내용이 없을 때 보여주는 화면

import Foundation
import SnapKit
import UIKit

final class SaveAlertViewController: UIViewController {
    private lazy var presenter = SaveAlertPresenter(viewController: self)

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
        label.text = "작성된 내용이 없습니다. 내용을 작성 한 후에 다시 시도해주세요."
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
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

extension SaveAlertViewController: SaveAlertProtocol {
    /// 뷰 구성
    func setupView() {
        view.backgroundColor = .black.withAlphaComponent(0.5)

        let alertStackView = UIStackView(arrangedSubviews: [messageLabel, confirmButton])
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
        confirmButton.titleLabel?.font = font.largeFont
    }

    /// 화면 닫기
    func dismiss() {
        dismiss(animated: false)
    }
}

// MARK: - @objc Function
extension SaveAlertViewController {
    /// 확인 버튼 클릭
    @objc func didTappedConfirmButton() {
        presenter.didTappedConfirmButton()
    }
}
