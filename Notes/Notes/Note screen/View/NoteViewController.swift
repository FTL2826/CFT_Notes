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
    var currentRange: NSRange?
    
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
        tv.textColor = .label
        tv.keyboardDismissMode = .interactive
        tv.keyboardType = .alphabet
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
                  let attrStr = self?.noteTextView.attributedText else { return }
            let note = NSMutableAttributedString(attributedString: attrStr)
            self?.viewModel.saveNote(for: self?.indexPath, title: title, noteContex: note)
            self?.coordinator?.popBack()
        })
        
        handleKeyboard()
    }
    
    private func populateView() {
        guard let indexPath = indexPath else { return }
        let note = viewModel.fetchNote(for: indexPath)
        titleTextField.text = note.title
        noteTextView.attributedText = note.noteContex
    }
    
    private func handleKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            noteTextView.contentInset = .zero
        } else {
            noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        noteTextView.scrollIndicatorInsets = noteTextView.contentInset
        
        let selectedRange = noteTextView.selectedRange
        noteTextView.scrollRangeToVisible(selectedRange)
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
        var submenu: UIMenu? = nil
        let string = NSMutableAttributedString(attributedString: textView.attributedText)

        if range.length > 0 {
            let submenuItems: [UIMenuElement] = [
                UIAction(title: "Bold", handler: { _ in
                    string.beginEditing()
                    string.enumerateAttribute(.font, in: range) { value, range, stop in
                        if let font = value as? UIFont {
                            let currentFontDescriptor = font.fontDescriptor
                            var traits = currentFontDescriptor.symbolicTraits
                            if traits.contains(.traitBold) {
                                traits.remove(.traitBold)
                            } else {
                                traits.insert(.traitBold)
                            }
                            guard let newFontDescriptor = currentFontDescriptor.withSymbolicTraits(traits) else { return }
                            let newFont = UIFont(descriptor: newFontDescriptor, size: newFontDescriptor.pointSize)
                            string.removeAttribute(.font, range: range)
                            string.addAttribute(.font, value: newFont, range: range)
                        }
                    }
                    string.endEditing()
                    textView.attributedText = string
                }),
                UIAction(title: "Italic", handler: { _ in
                    string.beginEditing()
                    string.enumerateAttribute(.font, in: range) { value, range, stop in
                        if let font = value as? UIFont {
                            let currentFontDescriptor = font.fontDescriptor
                            var traits = currentFontDescriptor.symbolicTraits
                            if traits.contains(.traitItalic) {
                                traits.remove(.traitItalic)
                            } else {
                                traits.insert(.traitItalic)
                            }
                            guard let newFontDescriptor = currentFontDescriptor.withSymbolicTraits(traits) else { return }
                            let newFont = UIFont(descriptor: newFontDescriptor, size: newFontDescriptor.pointSize)
                            string.removeAttribute(.font, range: range)
                            string.addAttribute(.font, value: newFont, range: range)
                        }
                    }
                    string.endEditing()
                    textView.attributedText = string
                }),
                UIAction(title: "underline", handler: { _ in
                    string.beginEditing()
                    
                    if string.attribute(.underlineStyle, at: range.lowerBound, effectiveRange: nil) != nil {
                        string.removeAttribute(.underlineStyle, range: range)
                    } else {
                        string.addAttributes([.underlineStyle : NSUnderlineStyle.single.rawValue], range: range)
                    }
                    string.endEditing()
                    textView.attributedText = string
                }),
                UIAction(title: "Strikethrough", handler: { _ in
                    string.beginEditing()
                    
                    if string.attribute(.strikethroughStyle, at: range.lowerBound, effectiveRange: nil) != nil {
                        string.removeAttribute(.strikethroughStyle, range: range)
                    } else {
                        string.addAttributes([.strikethroughStyle : NSUnderlineStyle.single.rawValue], range: range)
                    }
                    string.endEditing()
                    textView.attributedText = string
                })
            ]
            submenu = UIMenu(title: "BIU", children: submenuItems)
            
            let changeFontAction = UIAction(title: "Font", handler: {[weak self] _ in
                guard let self = self else { return }
                self.currentRange = range
                self.coordinator?.showFontPicker(with: self)
            })
            
            let changeFontSizeAction = UIAction(title: "Size", handler: {[weak self] _ in
                guard var newFontSize: CGFloat = textView.font?.pointSize else { return }
                let ac = UIAlertController(title: "Enter font size", message: nil, preferredStyle: .alert)
                ac.addTextField { tf in
                    tf.placeholder = "18"
                    tf.keyboardType = .numberPad
                }
                ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    guard let text = ac.textFields?.first?.text,
                            let size = Int(text) else { return }
                    newFontSize = CGFloat(size)
                    string.beginEditing()
                    string.enumerateAttribute(.font, in: range) { value, range, stop in
                        if let font = value as? UIFont {
                            let fontDescriptor = font.fontDescriptor.withFamily(font.familyName)
                            let newFont = UIFont(descriptor: fontDescriptor, size: newFontSize)
                            string.removeAttribute(.font, range: range)
                            string.addAttribute(.font, value: newFont, range: range)
                        }
                    }
                    string.endEditing()
                    textView.attributedText = string
                }))
                self?.currentRange = range
                self?.present(ac, animated: true)
            })
            
            let fontSubmenu = UIMenu(title: "Change font", children: [changeFontAction, changeFontSizeAction])
            
            if let submenu = submenu {
                let submenuItem: [UIMenuElement] = [submenu, fontSubmenu]
                return UIMenu(children: submenuItem + suggestedActions)
            }
        } else if range.length == 0 {
            let imageAttachItem: UIMenuElement = UIAction(title: "Image attach") {[weak self] _ in
                guard let self = self else { return }
                self.currentRange = range
                self.coordinator?.showImagePicker(with: self)
            }
            return UIMenu(children: [imageAttachItem] + suggestedActions )
        }
        return UIMenu(children: suggestedActions)
    }
}

extension NoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage,
              let currentRange = currentRange else { return }
        dismiss(animated: true) {[weak self] in
            guard let self = self else { return }
            let imageSize = self.noteTextView.bounds.width
            let string = NSMutableAttributedString(attributedString: self.noteTextView.attributedText)
            let attachment = NSTextAttachment(image: image.resized(to: CGSize(width: imageSize, height: imageSize)))
            let attrString = NSAttributedString(attachment: attachment)
            string.insert(attrString, at: currentRange.location)
            self.noteTextView.attributedText = string
        }
    }
}

extension NoteViewController: UIFontPickerViewControllerDelegate {
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        guard let font = viewController.selectedFontDescriptor,
              let currentRange = currentRange else { return }
        dismiss(animated: true) {[weak self] in
            guard let self = self else { return }
            let fontSize = self.noteTextView.font?.pointSize ?? 18
            let string = NSMutableAttributedString(attributedString: self.noteTextView.attributedText)
            string.setAttributes([.font : UIFont(descriptor: font, size: fontSize)], range: currentRange)
            self.noteTextView.attributedText = string
        }
    }
}
