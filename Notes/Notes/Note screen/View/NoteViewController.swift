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
    
    var indexPath: IndexPath?
    
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
        tv.delegate = self
        return tv
    }()
    
    init(
        viewModel: NoteViewViewModelProtocol,
        coordinator: Coordinator,
        indexPath: IndexPath? = nil
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.indexPath = indexPath
        
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
                  let note = self?.noteTextView.attributedText else { return }
            self?.viewModel.saveNote(for: self?.indexPath, title: title, noteContex: note)
            self?.coordinator?.popBack()
        })
    }
    
    @objc func runCut() {
        print("DEBUG PRINT:", "cut")
    }
    @objc func runCopy() {
        print("DEBUG PRINT:", "copy")
    }
    @objc func runPaste() {
        print("DEBUG PRINT:", "paste")
    }
    @objc func runPasteSearch() {
        print("DEBUG PRINT:", "pastesearch")
    }
    @objc func runLook() {
        print("DEBUG PRINT:", "look")
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
        guard let indexPath = indexPath else { return }
        let note = viewModel.fetchNote(for: indexPath)
        titleTextField.text = note.title
        noteTextView.attributedText = note.noteContex
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

extension NoteViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, editMenuForTextIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
        var additionalActions: [UIMenuElement] = []
        if range.length > 0 {
            let highlightAction = UIAction(title: "Highlight", image: UIImage(systemName: "highlighter")) { action in
                // The highlight action.
            }
            additionalActions.append(highlightAction)
        }
        let addBookmarkAction = UIAction(title: "Add Bookmark", image: UIImage(systemName: "bookmark")) { action in
            // The bookmark action.
        }
        additionalActions.append(addBookmarkAction)
        return UIMenu(children: additionalActions + suggestedActions)
    }
}
