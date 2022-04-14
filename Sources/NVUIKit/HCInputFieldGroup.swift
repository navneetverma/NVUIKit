//
//  HCInputFieldGroup.swift
//  HealthcareIP
//
//  Created by Navneet.verma on 2/14/22.
//

import Foundation
import UIKit
public class HCInputFieldGroup: HCInputFieldDelegate {

    public var fields: [HCInputField]
    public var shouldClearErrors: Bool
    public var textFieldDidChangeBlock: ((String?, HCInputField) -> Void)?
    public var didTapOnBiometric: (() -> Void)?
    public var completion: (() -> Void)?
    private var previousEditedTextField: HCInputField?


    // MARK: - Lifecycle
    public init(fields: [HCInputField],
                shouldClearErrors: Bool = false,
                textFieldTextDidChange: ((String?, HCInputField) -> Void)? = nil,
                completion: (() -> Void)? = nil,
                didTapOnBiometric: (() -> Void)? = nil) {

        self.fields = fields
        self.shouldClearErrors = shouldClearErrors
        self.textFieldDidChangeBlock = textFieldTextDidChange
        self.didTapOnBiometric = didTapOnBiometric
        self.completion = completion
        fields.forEach { $0.delegate = self }
    }

    // MARK: - Actions


    public func becomeFirstResponder() {
       fields.first?.becomeFirstResponder()
    }


    public func resignFirstResponder() {
        fields.forEach { _ = $0.resignFirstResponder() }
    }


    public func clearErrors(temporaryErrors: Bool = true,
                            errors: Bool = true) {
        fields.forEach { inputField in
            if errors {
                inputField.error = nil
            }
            if temporaryErrors {
                inputField.temporaryError = nil
            }
        }
    }


    // MARK: - InputFieldDelegate


    public func textFieldTextDidChange(_ text: String?, from inputField: HCInputField) {
        defer {
            textFieldDidChangeBlock?(text, inputField)
        }
        guard
            shouldClearErrors,
            inputField != previousEditedTextField
            else { return }
        previousEditedTextField = inputField
        inputField.temporaryError = nil
        fields.forEach { $0.error = nil }
    }

    public func canMoveToNextField(from: HCInputField) -> Bool {
        defer { previousEditedTextField = nil }
        guard let index = fields.firstIndex(of: from) else { return false }
        return index < fields.count - 1
    }

    public func moveToNextField(after: HCInputField) {
        defer { previousEditedTextField = nil }
        guard let index = fields.firstIndex(of: after) else { return }
        if index < fields.count - 1 {
            _ = fields[index+1].becomeFirstResponder()

        } else {
            fields.forEach { $0.validate() }
            if fields.allSatisfy({ $0.error == nil && $0.temporaryError == nil }) {
                completion?()
            }
        }
    }
    public func didtapOnBiometric() {
        didTapOnBiometric?()
    }
}

class HCTextFieldContainer: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let stackView = subviews.first as? UIStackView else { return self }
        let p = stackView.convert(point, from: self)
        return stackView.subviews.first { view -> Bool in
            return view.frame.insetBy(dx: -10, dy: -10).contains(p)
        }
    }
}

