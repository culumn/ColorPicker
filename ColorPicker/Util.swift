//
//  Util.swift
//  ColorPicker
//
//  Created by Matsuoka Yoshiteru on 2018/10/20.
//  Copyright © 2018年 culumn. All rights reserved.
//

func convertHSBToRGB(_ hsb: HSB) -> RGB {
    // Converts HSB to a RGB color
    var rgb = RGB(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
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

    rgb.red = red
    rgb.green = green
    rgb.blue = blue
    rgb.alpha = hsb.alpha
    return rgb
}

func convertRGBToHSB(_ rgb: RGB) -> HSB {
    // Converts RGB to a HSB color
    var hsb = HSB(hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 0.0)

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

    hsb.hue = hue
    hsb.saturation = saturation
    hsb.brightness = brightness
    hsb.alpha = rgb.alpha
    return hsb
}
