//
//  FontManager.swift
//  Memo
//
//  Created by 김민지 on 2022/04/29.
//

import Foundation
import UIKit

enum FontSize: CGFloat {
    case small = 12
    case medium = 14
    case large = 16
    case extraLarge = 20
    case twoExtraLarge = 25
}

enum Font: Int {
    case kyobo          // 교보손글씨

    static let allValues = [
        kyobo
    ]

    /// 아이폰 글씨(size: 12)
    var smallFont: UIFont {
        switch self {
        case .kyobo:
            return UIFont(name: "KyoboHandwriting2019", size: FontSize.small.rawValue)!
        }
    }

    /// 아이폰 글씨(size: 14)
    var mediumFont: UIFont {
        switch self {
        case .kyobo:
            return UIFont(name: "KyoboHandwriting2019", size: FontSize.medium.rawValue)!
        }
    }

    /// 아이폰 글씨(size: 16)
    var largeFont: UIFont {
        switch self {
        case .kyobo:
            return UIFont(name: "KyoboHandwriting2019", size: FontSize.large.rawValue)!
        }
    }

    /// 아이폰 글씨(size: 18)
    var extraLargeFont: UIFont {
        switch self {
        case .kyobo:
            return UIFont(name: "KyoboHandwriting2019", size: FontSize.extraLarge.rawValue)!
        }
    }

    /// 아이폰 글씨(size: 20)
    var twoExtraLargeFont: UIFont {
        switch self {
        case .kyobo:
            return UIFont(name: "KyoboHandwriting2019", size: FontSize.twoExtraLarge.rawValue)!
        }
    }
}

let fontKey = "Font"

class FontManager {
    /// 저장된 폰트 가져오기
    static func getFont() -> Font {
        if let font = (UserDefaults.standard.value(forKey: fontKey) as AnyObject).integerValue {
            return Font(rawValue: font)!
        } else {
            // 저장된 폰트가 없으면 기본 폰트로
            return .kyobo
        }
    }
    /// 폰트 저장하기
    static func setFont(font: Font) {
        UserDefaults.standard.setValue(font.rawValue, forKey: fontKey)
        UserDefaults.standard.synchronize()
    }
}
