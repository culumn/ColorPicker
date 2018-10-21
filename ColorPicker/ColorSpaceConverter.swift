//
//  Util.swift
//  ColorPicker
//
//  Created by Matsuoka Yoshiteru on 2018/10/20.
//  Copyright © 2018年 culumn. All rights reserved.
//

/// The class converts the color spaces.
final class ColorSpaceConverter {

    /// Convert to the RGB color space for a given HSB color space.
    ///
    /// - Parameter hsb: The HSB color space.
    /// - Returns: The RGB color space corresponding the HSB color space.
    class func convertToRGB(hsb: HSB) -> RGB {
        let color = hsb.color
        return color.rgb
    }

    /// Convert to the HSB color space for a given RGB color space.
    ///
    /// - Parameter rgb: The RGB color space.
    /// - Returns: The HSB color space corresponding the RGB color space.
    class func convertToHSB(rgb: RGB) -> HSB {
        let color = rgb.color
        return color.hsb
    }
}
