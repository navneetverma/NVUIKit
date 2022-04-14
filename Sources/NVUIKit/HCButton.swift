//
//  HCButton.swift
//  HealthcareIP
//
//  Created by Jigar.Patel on 2/15/22.
//

import UIKit

public class HCButton: UIButton {
    enum ButtonType {
        case filled
        case normal
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String, type: ButtonType = .normal) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        layer.cornerRadius = 15
        layer.masksToBounds = true
        switch type {
        case .filled:
            layer.borderWidth = 0
            setTitleColor(.white, for: .normal)
            backgroundColor = UIColor.orange
        default:
            layer.borderWidth = 1
            layer.borderColor = UIColor.black.cgColor
            setTitleColor(.black, for: .normal)
            backgroundColor = .white
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.cornerRadius = 15
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        setTitleColor(.black, for: .normal)
        backgroundColor = .white
    }
    func setStyle(type: ButtonType = .normal) {
        switch type {
        case .filled:
            layer.borderWidth = 0
            setTitleColor(.white, for: .normal)
            backgroundColor = UIColor.orange
        default:
            layer.borderWidth = 1
            layer.borderColor = UIColor.black.cgColor
            setTitleColor(.black, for: .normal)
            backgroundColor = .white
        }
    }
    
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
    }
}
