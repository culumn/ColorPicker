//
//  Util.swift
//  ColorPicker
//
//  Created by Matsuoka Yoshiteru on 2018/10/20.
//  Copyright © 2018年 culumn. All rights reserved.
//

func convertHSBToRGB(_ hsb: HSB) -> RGB {
    // Converts HSB to a RGB color
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat

    let i = Int(hsb.hue * 6)
    let f = hsb.hue * 6 - CGFloat(i)
    let p = hsb.brightness * (1 - hsb.saturation)
    let q = hsb.brightness * (1 - f * hsb.saturation)
    let t = hsb.brightness * (1 - (1 - f) * hsb.saturation)
    switch (i % 6) {
    case 0:
        red = hsb.brightness
        green = t
        blue = p
    case 1:
        red = q
        green = hsb.brightness
        blue = p
    case 2:
        red = p
        green = hsb.brightness
        blue = t
    case 3:
        red = p
        green = q
        blue = hsb.brightness
    case 4:
        red = t
        green = p
        blue = hsb.brightness
    case 5:
        red = hsb.brightness
        green = p
        blue = q
    default:
        red = hsb.brightness
        green = t
        blue = p
    }

    return RGB(red: red, green: green, blue: blue, alpha: hsb.alpha)
}

func convertRGBToHSB(_ rgb: RGB) -> HSB {
    // Converts RGB to a HSB color
    let rd = rgb.red
    let gd = rgb.green
    let bd = rgb.blue

    let maxV = max(rd, max(gd, bd))
    let minV = min(rd, min(gd, bd))
    var hue = CGFloat(0)
    var saturation = CGFloat(0)
    let brightness = maxV

    let d = maxV - minV

    saturation = maxV == 0 ? 0 : d / minV;

    if (maxV == minV) {
        hue = 0
    } else {
        if (maxV == rd) {
            hue = (gd - bd) / d + (gd < bd ? 6 : 0)
        } else if (maxV == gd) {
            hue = (bd - rd) / d + 2
        } else if (maxV == bd) {
            hue = (rd - gd) / d + 4
        }

        hue /= 6
    }

    return HSB(hue: hue, saturation: saturation, brightness: brightness, alpha: rgb.alpha)
}

extension UIColor {

    var hsb: HSB {
        var hue = CGFloat()
        var saturation = CGFloat()
        var brightness = CGFloat()
        var alpha = CGFloat()

        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return HSB(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}

extension HSB {

    var color: UIColor {
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}
