//
//  ProjectManager - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {

    // MARK: - Outlet
    
    lazy var todoTableView = makeTableView()
    lazy var doingTableView = makeTableView()
    lazy var doneTableView = makeTableView()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureConstratins()
    }

    // MARK: - UI
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(ThingTableViewCell.self, forCellReuseIdentifier: ThingTableViewCell.identifier)
        return tableView
    }
    
    private func configureConstratins() {
        let safeArea = view.safeAreaLayoutGuide
        let stackView = UIStackView(arrangedSubviews: [todoTableView, doingTableView, doneTableView])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .systemGray3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .white
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.title = Strings.navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(touchUpAddButton))
    }
    
    @objc private func touchUpAddButton() {
        
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == todoTableView {
            return Things.shared.todoList.count
        } else if tableView == doingTableView {
            return Things.shared.doingList.count
        } else {
            return Things.shared.doneList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ThingTableViewCell.identifier) as? ThingTableViewCell else {
            return UITableViewCell()
        }
        if tableView == todoTableView {
            cell.configureCell(Things.shared.todoList[indexPath.row])
        } else if tableView == doingTableView {
            cell.configureCell(Things.shared.doingList[indexPath.row])
        } else {
            cell.configureCell(Things.shared.doneList[indexPath.row])
        }
        return cell
    }
}
