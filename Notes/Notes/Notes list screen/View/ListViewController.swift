//
//  ListViewContro.swift
//  Notes
//
//  Created by Александр Харин on /163/23.
//

import UIKit

class ListViewController: UIViewController {
    
    let viewModel: ListViewViewModelProtocol
    weak var coordinator: Coordinator?
    
    let identifier = "CellIdentifier"
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorColor = .black
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    
    init(
        viewModel: ListViewViewModelProtocol,
        coordinator: Coordinator
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction { [weak self] _ in
            self?.coordinator?.showNewNoteScreen()
        })
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }


}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.rowsInTable()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        }
        guard let cell = cell else { fatalError("couldnt create cell") }
        
        cell.accessoryType = .disclosureIndicator
        
        cell.textLabel?.text = viewModel.titleForRow(index: indexPath.item)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        cell.detailTextLabel?.text = viewModel.subtitleForRow(index: indexPath.item)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showExistNoteScreen(for: indexPath.item)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.deleteNote(for: indexPath.item)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
}

