//
//  RGB.swift
//  ColorPicker
//
//  Created by Matsuoka Yoshiteru on 2018/10/19.
//  Copyright © 2018年 culumn. All rights reserved.
//

import Foundation

public struct RGB {
    public var red: CGFloat
    public var green: CGFloat
    public var blue: CGFloat
    public var alpha: CGFloat

    public var color: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
