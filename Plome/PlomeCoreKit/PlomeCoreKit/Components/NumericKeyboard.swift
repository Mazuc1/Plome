//
//  NumericKeyboard.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 09/06/2023.
//

import UIKit

private class DigitButton: UIButton {
    var digit: Int = 0
}

public class NumericKeyboard: UIView {
    weak var target: (UIKeyInput & UITextInput)?
    
    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: Self.keyboardHeight)
    }
    
    private static let keyboardHeight: CGFloat = 275

    private var numericButtons: [DigitButton] = (0...9).map {
        let button = DigitButton(type: .system)
        button.digit = $0
        button.setTitle("\($0)", for: .normal)
        button.titleLabel?.font = PlomeFont.custom(size: 23, weight: .medium).font
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = PlomeColor.background.color
        button.layer.cornerRadius = AppStyles.defaultRadius
        return button
    }

    private var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("⌫", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = PlomeColor.background.color
        button.layer.cornerRadius = AppStyles.defaultRadius
        return button
    }()

    private lazy var decimalButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(".", for: .normal)
        button.titleLabel?.font = PlomeFont.custom(size: 23, weight: .medium).font
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = PlomeColor.background.color
        button.layer.cornerRadius = AppStyles.defaultRadius
        return button
    }()

    public init(target: UIKeyInput & UITextInput) {
        self.target = target
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Actions

private extension NumericKeyboard {
    @objc func didTapDigitButton(_ sender: DigitButton) {
        insertText("\(sender.digit)")
    }

    @objc func didTapDecimalButton(_ sender: DigitButton) {
        insertText(".")
    }

    @objc func didTapDeleteButton(_ sender: DigitButton) {
        playKeySound()
        target?.deleteBackward()
    }
}

// MARK: - Private initial configuration methods

private extension NumericKeyboard {
    func configure() {
        numericButtons.forEach {
            $0.addTarget(self, action: #selector(didTapDigitButton(_:)), for: .touchUpInside)
        }
        
        deleteButton.addTarget(
            self, action: #selector(didTapDeleteButton(_:)), for: .touchUpInside)
        decimalButton.addTarget(self, action: #selector(didTapDecimalButton(_:)), for: .touchUpInside)

        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addButtons()
    }

    func addButtons() {
        let stackView = createStackView(axis: .vertical).configure {
            $0.frame = bounds
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = .init(top: AppStyles.defaultSpacing,
                                            left: AppStyles.defaultSpacing,
                                            bottom: AppStyles.defaultSpacing,
                                            right: AppStyles.defaultSpacing)
        }
        
        addSubview(stackView)

        for row in 0 ..< 3 {
            let subStackView = createStackView(axis: .horizontal)
            stackView.addArrangedSubview(subStackView)

            for column in 0 ..< 3 {
                subStackView.addArrangedSubview(numericButtons[row * 3 + column + 1])
            }
        }

        let subStackView = createStackView(axis: .horizontal)
        stackView.addArrangedSubview(subStackView)

        subStackView.addArrangedSubview(decimalButton)
        subStackView.addArrangedSubview(numericButtons[0])
        subStackView.addArrangedSubview(deleteButton)
    }

    func createStackView(axis: NSLayoutConstraint.Axis) -> UIStackView {
        UIStackView().configure {
            $0.axis = axis
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = AppStyles.defaultSpacing
        }
    }

    func insertText(_ string: String) {
        guard let range = target?.selectedRange else { return }

        if let textField = target as? UITextField, textField.delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) == false {
            return
        }

        if let textView = target as? UITextView, textView.delegate?.textView?(textView, shouldChangeTextIn: range, replacementText: string) == false {
            return
        }

        playKeySound()
        target?.insertText(string)
    }
    
    func playKeySound() {
        UIDevice.current.playInputClick()
    }
}

// MARK: - UITextInput extension

extension UITextInput {
    var selectedRange: NSRange? {
        guard let textRange = selectedTextRange else { return nil }

        let location = offset(from: beginningOfDocument, to: textRange.start)
        let length = offset(from: textRange.start, to: textRange.end)
        return NSRange(location: location, length: length)
    }
}
