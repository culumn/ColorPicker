//
//  UIColorExtension.swift
//  ColorPicker
//
//  Created by Matsuoka Yoshiteru on 2018/10/20.
//  Copyright © 2018年 culumn. All rights reserved.
//

import Foundation

public extension UIColor {

    var hsb: HSB? {
        var hue = CGFloat()
        var saturation = CGFloat()
        var brightness = CGFloat()
        var alpha = CGFloat()

        return getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            ? HSB(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
            : nil
    }

    var rgb: RGB? {
        var red = CGFloat()
        var green = CGFloat()
        var blue = CGFloat()
        var alpha = CGFloat()

        return getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            ? RGB(red: red, green: green, blue: blue, alpha: alpha)
            : nil
    }
}
