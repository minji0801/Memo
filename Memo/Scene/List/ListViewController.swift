//
//  ListViewController.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//  메모 목록 화면

import SnapKit
import UIKit

final class ListViewController: UIViewController {
    private lazy var presenter = ListPresenter(viewController: self)

    /// 왼쪽 바 버튼: 메뉴 버튼
    private lazy var leftBarButton = UIBarButtonItem(
        image: UIImage(systemName: "ellipsis"),
        style: .plain,
        target: self,
        action: #selector(didTappedLeftBarButton)
    )

    /// 오른쪽 바 버튼: 메모 작성 버튼
    private lazy var rightBarButton = UIBarButtonItem(
        image: UIImage(systemName: "square.and.pencil"),
        style: .plain,
        target: self,
        action: #selector(didTappedRightBarButton)
    )

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = presenter
        tableView.delegate = presenter

        tableView.register(
            ListTableViewCell.self,
            forCellReuseIdentifier: ListTableViewCell.identifier
        )

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
        // 폰트 체크 하기
//        UIFont.familyNames.sorted().forEach { familyName in
//            print("*** \(familyName) ***")
//            UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
//                print("\(fontName)")
//            }
//            print("---------------------")
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
        print(UserDefaultsManager().getMemos())
        print(UserDefaultsManager().getMemoId())
    }
}

// MARK: - ListProtocol Function
extension ListViewController: ListProtocol {
    /// 네비게이션 바 구성
    func setupNavigationBar() {
        navigationItem.title = "메모 목록"
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton

        let font = FontManager.getFont()
        navigationController?.navigationBar.titleTextAttributes = [
            .font: font.extraLargeFont
        ]
    }

    /// 뷰 구성
    func setupView() {
        view.backgroundColor = .systemBackground

        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    /// 테이블 뷰 다시 로드하기
    func reloadTableView() {
        tableView.reloadData()
    }

    /// 메모 작성 화면 보여주기
    func pushToWriteViewController() {
        let writeViewController = WriteViewController()
        navigationController?.pushViewController(writeViewController, animated: true)
    }

    /// 메모 상세 화면 보여주기
    func pushToDetailViewController(_ memo: Memo) {
        let detailViewController = DetailViewController(memo: memo)
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    /// 팝업 메뉴 보여주기
    func showListPopupViewController(_ popoverContentController: ListPopupViewController) {
        present(popoverContentController, animated: true, completion: nil)
    }
}

// MARK: - @objc Function
extension ListViewController {
    @objc func didTappedLeftBarButton(_ sender: UIBarButtonItem) {
        presenter.didTappedLeftBarButton(sender)
    }

    @objc func didTappedRightBarButton() {
        presenter.didTappedRightBarButton()
    }
}
