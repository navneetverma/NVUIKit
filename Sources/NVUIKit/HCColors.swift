//
//  HCColors.swift
//  HealthcareIP
//
//  Created by Navneet.verma on 2/14/22.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexadecimal: String) {
        var hexString: String = hexadecimal.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        if hexString.count != 6 {
            fatalError("The color hex code should be 6 chars in length.")
        }
        var rgbValue: UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&rgbValue)
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: CGFloat(1.0))
    }


    enum Gray {
        public static let border = UIColor(hexadecimal: "C4C4C4")
        public static let dark = UIColor(hexadecimal: "4F575D")
        public static let light = UIColor(hexadecimal: "F4F4F4")
        public static let container = UIColor(hexadecimal: "F5F5F5")
        public static let info = UIColor(hexadecimal: "849096")
        public static let disabled = UIColor(hexadecimal: "B5C0C6")
        public static let placeholderText = UIColor(hexadecimal: "737373")
        public static let lineBackground = UIColor(hexadecimal: "")
        public static let backgroundlight = UIColor(hexadecimal: "EFEFEF")
        public static let background = UIColor(hexadecimal: "F4F6F8")
        public static let regent = UIColor(hexadecimal: "8A979D")
        public static let text = UIColor(hexadecimal: "")
    }
    
    public enum Red {
        public static let base = UIColor(hexadecimal: "D31145")
        public static let error = UIColor(hexadecimal: "FF453A")
        public static let button = UIColor(hexadecimal: "BB0000")
        public static let backGround = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
    }
    
    public enum Green {
        public static let base = UIColor(hexadecimal: "28F29C")
        public static let light = UIColor(hexadecimal: "A8C599")
        public static let dark = UIColor(hexadecimal: "1E561F")

    }
    
    public enum Blue {
        public static let light =  UIColor(hexadecimal: "0B7FA2")
        public static let ribbon =  UIColor(hexadecimal: "006EE6")
        public static let text = UIColor(hexadecimal: "8A979D")
        public static let dot =   UIColor(hexadecimal: "00A9E0")
        public static let mitchell = UIColor(hexadecimal: "0d7fa2")

    }
    
    public enum Background {
        public static let red =  UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
        public static let black =  UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        public static let black1 =  UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        public static let black2 =  UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        public static let gray = UIColor(hexadecimal: "F4F6F8")
        public static let error = UIColor(hexadecimal: "FFF6F6")
    }
    
    public enum Status {
        public static let warning = UIColor(hexadecimal: "EBAD56")
        public static let success = UIColor(hexadecimal: "E36666")
        public static let error = UIColor(hexadecimal: "78CE7A")
    }
    
    public enum Slate {
        public static let base = UIColor(hexadecimal: "415364")
        public static let dark = UIColor(hexadecimal: "213242")
        public static let midnight = UIColor(hexadecimal: "2B2F35")
    }
    
    public static let testCardBackground = UIColor(hexadecimal: "F3F3F5")
    public static let norway = UIColor(hexadecimal: "A8C599")
    public static let parisPaving = UIColor(hexadecimal: "767577")
    public static let magenta = UIColor(hexadecimal: "BA979D")
    public static let antiquate = UIColor(hexadecimal: "8a879d")
    public static let tribeccaCorner = UIColor(hexadecimal: "33373B")
    public static let shadowMountain = UIColor(hexadecimal: "595959")
    public static let midnight = UIColor(hexadecimal: "3A474D")
    public static let alabaster = UIColor(hexadecimal: "F9F8F9")
    public static let palesky = UIColor(hexadecimal: "6C7781")
    public static let iron = UIColor(hexadecimal: "DFE0E2")
    public static let ceramic = UIColor(hexadecimal: "FCFFF5")
    public static let rodeoDust = UIColor(hexadecimal: "C9B094")
    public static let orange = UIColor(hexadecimal: "CC4E00")
    
}
