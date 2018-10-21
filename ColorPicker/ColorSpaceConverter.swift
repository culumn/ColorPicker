//
//  Util.swift
//  ColorPicker
//
//  Created by Matsuoka Yoshiteru on 2018/10/20.
//  Copyright © 2018年 culumn. All rights reserved.
//

final class ColorSpaceConverter {

    func convertHSBToRGB(_ hsb: HSB) -> RGB {
        let color = hsb.color
        return color.rgb
    }

    func convertRGBToHSB(_ rgb: RGB) -> HSB {
        let color = rgb.color
        return color.hsb
    }
}
