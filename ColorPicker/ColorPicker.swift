//
//  ColorWheelView.swift
//  ColorPicker
//
//  Created by Matsuoka Yoshiteru on 2018/10/19.
//  Copyright © 2018年 culumn. All rights reserved.
//

import Foundation

public protocol ColorPickerViewDelegate: class {
    func colorPicker(
        _ colorPicker: ColorPicker,
        didSelect color: UIColor)
}

@IBDesignable
public class ColorPicker: UIView {

    let scale: CGFloat = UIScreen.main.scale

    public weak var delegate: ColorPickerViewDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        layer.contents = createColorWheelImage(size: frame.size)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        layer.contents = createColorWheelImage(size: frame.size)
    }

    func createColorWheelImage(size: CGSize) -> CGImage {
        // Creates a bitmap of the Hue Saturation wheel
        let originalWidth: CGFloat = size.width
        let originalHeight: CGFloat = size.height
        let dimension: CGFloat = min(originalWidth*scale, originalHeight*scale)
        let bufferLength: Int = Int(dimension * dimension * 4)

        let bitmapData: CFMutableData = CFDataCreateMutable(nil, 0)
        CFDataSetLength(bitmapData, CFIndex(bufferLength))
        let bitmap = CFDataGetMutableBytePtr(bitmapData)

        for y in stride(from: CGFloat(0), to: dimension, by: CGFloat(1)) {
            for x in stride(from: CGFloat(0), to: dimension, by: CGFloat(1)) {
                var hsb = HSB(hue: 0, saturation: 0, brightness: 0, alpha: 0)
                var rgb = RGB(red: 0, green: 0, blue: 0, alpha: 0)

                let point = CGPoint(x: x, y: y)
                let color = getHSValue(at: point)
                let hue = color.hue
                let saturation = color.saturation
                var a: CGFloat = 0.0
                if (saturation < 1.0) {
                    // Antialias the edge of the circle.
                    if (saturation > 0.99) {
                        a = (1.0 - saturation) * 100
                    } else {
                        a = 1.0;
                    }

                    hsb.hue = hue
                    hsb.saturation = saturation
                    hsb.brightness = 1.0
                    hsb.alpha = a
                    rgb = convertHSBToRGB(hsb)
                }
                let offset = Int(4 * (x + y * dimension))
                bitmap?[offset] = UInt8(rgb.red*255)
                bitmap?[offset + 1] = UInt8(rgb.green*255)
                bitmap?[offset + 2] = UInt8(rgb.blue*255)
                bitmap?[offset + 3] = UInt8(rgb.alpha*255)
            }
        }

        // Convert the bitmap to a CGImage
        let colorSpace: CGColorSpace? = CGColorSpaceCreateDeviceRGB()
        let dataProvider: CGDataProvider? = CGDataProvider(data: bitmapData)
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.last.rawValue)
        let imageRef = CGImage(
            width: Int(dimension),
            height: Int(dimension),
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: Int(dimension) * 4,
            space: colorSpace!,
            bitmapInfo: bitmapInfo,
            provider: dataProvider!,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent)
        return imageRef!
    }

    func getHSValue(at point: CGPoint) -> (hue: CGFloat, saturation: CGFloat) {
        // Get hue and saturation for a given point (x,y) in the wheel

        let c = frame.width * scale / 2
        let dx = CGFloat(point.x - c) / c
        let dy = CGFloat(point.y - c) / c
        let d = sqrt(CGFloat (dx * dx + dy * dy))

        let saturation = d

        var hue: CGFloat
        if (d == 0) {
            hue = 0
        } else {
            hue = acos(dx/d) / CGFloat.pi / 2.0
            if (dy < 0) {
                hue = 1.0 - hue
            }
        }
        return (hue, saturation)
    }

}
