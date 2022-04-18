//
//  HCLinkButton.swift
//  HealthcareIP
//
//  Created by Jigar.Patel on 2/25/22.
//

import UIKit

public class HCLinkButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(UIColor.Blue.mitchell, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 15.0)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        if #available(iOS 13.0, *) {
            if #available(iOS 14.0, *) {
                addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
            } else {
                // Fallback on earlier versions
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
extension UIButton {
    func underline() {
        guard let title = self.titleLabel else { return }
        guard let tittleText = title.text else { return }
        let attributedString = NSMutableAttributedString(string: (tittleText))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: (tittleText.count)))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
