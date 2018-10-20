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
    public var brue: CGFloat
    public var alpha: CGFloat

    public init(
        red: CGFloat,
        green: CGFloat,
        brue: CGFloat,
        alpha: CGFloat) {
        self.red = red
        self.green = green
        self.brue = brue
        self.alpha = alpha
    }
}
