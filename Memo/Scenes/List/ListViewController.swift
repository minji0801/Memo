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

    /// 검색 창
    private lazy var searchcontroller: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "메모 검색"

        searchController.searchBar.keyboardType = .default
        searchController.searchBar.autocorrectionType = .no
        searchController.searchBar.spellCheckingType = .no
        searchController.searchBar.autocapitalizationType = .none

        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = false

        searchController.searchBar.delegate = presenter
        searchController.delegate = presenter

        return searchController
    }()

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
    }
}

// MARK: - ListProtocol Function
extension ListViewController: ListProtocol {
    func setupNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }

    func setupView() {
        view.backgroundColor = .systemBackground

        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - @objc Function
extension ListViewController {
    @objc func didTappedLeftBarButton(_ sender: UIBarButtonItem) {
        let popoverContentController = ListPopupViewController()
        popoverContentController.modalPresentationStyle = .popover
        popoverContentController.preferredContentSize = CGSize(width: 80, height: 100)

        if let popoverPresentationController = popoverContentController.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .right
            popoverPresentationController.barButtonItem = sender
            popoverPresentationController.delegate = self
            present(popoverContentController, animated: true, completion: nil)
        }
    }

    @objc func didTappedRightBarButton() {}
}

// MARK: - UIPopoverPresentationControllerDelegate
extension ListViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func popoverPresentationControllerDidDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController
    ) {

    }

    func popoverPresentationControllerShouldDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController
    ) -> Bool {
        return true
    }
}
