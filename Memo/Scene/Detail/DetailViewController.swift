//
//  DetailViewController.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  메모 상세 화면

import Foundation
import SnapKit
import UIKit

final class DetailViewController: UIViewController {
    private var presenter: DetailPresenter!

    init(memo: Memo) {
        super.init(nibName: nil, bundle: nil)
        presenter = DetailPresenter(viewController: self, memo: memo)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 왼쪽 바 버튼: 뒤로가기 버튼
    private lazy var leftBarButton = UIBarButtonItem(
        image: UIImage(systemName: "arrow.left"),
        style: .plain,
        target: self,
        action: #selector(didTappedLeftBarButton)
    )

    /// 오른쪽 바 버튼: 메뉴 버튼
    private lazy var menuRightBarButton = UIBarButtonItem(
        image: UIImage(systemName: "ellipsis"),
        style: .plain,
        target: self,
        action: #selector(didTappedMenuRightBarButton)
    )

    /// 오른쪽 바 버튼: 잠금 버튼
    private lazy var lockRightBarButton = UIBarButtonItem(
        image: UIImage(systemName: "lock"),
        style: .plain,
        target: self,
        action: nil
    )

    /// 메모 내용 텍스트 뷰
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false

        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }
}

extension DetailViewController: DetailProtocol {
    /// 네비게이션 바 구성
    func setupNavigationBar() {
        navigationItem.title = "메모 내용"
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItems = [menuRightBarButton, lockRightBarButton]
    }

    /// 뷰 구성
    func setupView(_ memo: Memo) {
        view.backgroundColor = .systemBackground

        if memo.isSecret {
            lockRightBarButton.image = UIImage(systemName: "lock.fill")
        } else {
            lockRightBarButton.image = UIImage(systemName: "lock")
        }

        textView.text = memo.content

        let attrString = NSMutableAttributedString(string: textView.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attrString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSMakeRange(0, attrString.length)
        )
        textView.attributedText = attrString

        view.addSubview(textView)

        let spacing: CGFloat = 16.0

        textView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(spacing)
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(spacing)
        }
    }

    /// 폰트 적용
    func applyFont() {
        let font = FontManager.getFont()

        textView.font = font.largeFont
    }

    /// 현재 뷰 pop
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    /// 팝업 메뉴 보여주기
    func showDetailPopupViewController(_ popoverContentController: DetailPopupViewController) {
        present(popoverContentController, animated: true, completion: nil)
    }
}

// MARK: - @objc Function
extension DetailViewController {
    /// 뒤로 가기 버튼 클릭 -> pop
    @objc func didTappedLeftBarButton() {
        presenter.didTappedLeftBarButton()
    }

    /// 메뉴 버튼 클릭 -> 메뉴(수정, 삭제) 보여주기
    @objc func didTappedMenuRightBarButton(_ sender: UIBarButtonItem) {
        presenter.didTappedMenuRightBarButton(sender)
    }
}
