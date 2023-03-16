//
//  NoteViewController.swift
//  Notes
//
//  Created by Александр Харин on /163/23.
//

import UIKit

class NoteViewController: UIViewController {
    
    var viewModel: NoteViewViewModelProtocol
    weak var coordinator: Coordinator?
    
    var index: Int?
    
    lazy var titleTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        tf.text = "New note"
        tf.delegate = self
        return tf
    }()
    lazy var noteTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        tv.isScrollEnabled = true
        return tv
    }()
    
    init(
        viewModel: NoteViewViewModelProtocol,
        coordinator: Coordinator,
        index: Int? = nil
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.index = index
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        populateView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .save, primaryAction: UIAction {[weak self] _ in
            guard let title = self?.titleTextField.text,
                  let note = self?.noteTextView.text else { return }
            self?.viewModel.saveNote(index: self?.index, title: title, noteContex: note)
            self?.coordinator?.popBack()
        })
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        noteTextView.becomeFirstResponder()
        
        [titleTextField, noteTextView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            titleTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            noteTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 12),
            noteTextView.centerXAnchor.constraint(equalTo: titleTextField.centerXAnchor),
            noteTextView.widthAnchor.constraint(equalTo: titleTextField.widthAnchor),
            noteTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    private func populateView() {
        guard let index = index else { return }
        let note = viewModel.fetchNote(for: index)
        titleTextField.text = note.title
        noteTextView.text = note.note
    }

}

extension NoteViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteTextView.becomeFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let oldText = textField.text else { return false }
        guard let stringRange = Range(range, in: oldText) else { return false }
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        return true
    }
    
    
    
}
