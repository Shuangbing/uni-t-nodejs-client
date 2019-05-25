//
//  Animation.swift
//  unitool
//
//  Created by そうへい on 2018/11/20.
//  Copyright © 2018 そうへい. All rights reserved.
//
import ViewAnimator
import CommonCrypto

let Animation_Table = [AnimationType.from(direction: .bottom, offset: 30.0)]
let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
let zoomAnimation = AnimationType.zoom(scale: 0.2)

let Color_Main = UIColor(hexString: "50505B")
let Color_Sub = UIColor(hexString: "31BFE1")
let Color_Back = UIColor(hexString: "F3F2F3")

let SubjectColor = [UIColor(hexString: "4c6ca0"),UIColor(hexString: "ff4945"),UIColor(hexString: "ff7eb9"),UIColor(hexString: "ffcc00"),UIColor(hexString: "663656"),UIColor(hexString: "9b30ff"),UIColor(hexString: "fb9292"),UIColor(hexString: "009BB2"),UIColor(hexString: "3c3c3c"),UIColor(hexString: "655252")]

extension UIColor {
    convenience init(hex: String, alpha: CGFloat) {
        let v = hex.map { String($0) } + Array(repeating: "0", count: max(6 - hex.count, 0))
        let r = CGFloat(Int(v[0] + v[1], radix: 16) ?? 0) / 255.0
        let g = CGFloat(Int(v[2] + v[3], radix: 16) ?? 0) / 255.0
        let b = CGFloat(Int(v[4] + v[5], radix: 16) ?? 0) / 255.0
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
    
    convenience init(hexString: String) {
        self.init(hex: hexString, alpha: 1.0)
    }
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: abs(percentage) )!
    }
    
    func darkened(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: -1 * abs(percentage) )!
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}

extension UIFont {
    static var screenFontSize: CGFloat {
        switch UIScreen.main.bounds.size {
        case CGSize(width: 320.0, height: 480.0): return 8 //iPhone4S
        case CGSize(width: 320.0, height: 568.0): return 10.5 //iPhone5,iPhone5S,iPodTouch5
        case CGSize(width: 375.0, height: 667.0): return 12 //iPhone6
        case CGSize(width: 414.0, height: 736.0): return 14 //iPhone6Plus
        case CGSize(width: 375.0, height: 812.0): return 14 //iPhoneX XS
        case CGSize(width: 414.0, height: 896.0): return 15 //iPhoneXR XSM
        default:  return 17
        }
    }
}

extension String {
    var md5: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
