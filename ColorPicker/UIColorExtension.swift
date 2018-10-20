//
//  UIColorExtension.swift
//  ColorPicker
//
//  Created by Matsuoka Yoshiteru on 2018/10/20.
//  Copyright © 2018年 culumn. All rights reserved.
//

import Foundation

public extension UIColor {

    var hsb: HSB {
        var hue = CGFloat()
        var saturation = CGFloat()
        var brightness = CGFloat()
        var alpha = CGFloat()

        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return HSB(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    var rgb: RGB {
        var red = CGFloat()
        var green = CGFloat()
        var blue = CGFloat()
        var alpha = CGFloat()

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGB(red: red, green: green, blue: blue, alpha: alpha)
    }
}
