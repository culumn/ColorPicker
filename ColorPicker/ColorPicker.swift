//
//  ColorWheelView.swift
//  ColorPicker
//
//  Created by Matsuoka Yoshiteru on 2018/10/19.
//  Copyright © 2018年 culumn. All rights reserved.
//

import Foundation

@IBDesignable
public class ColorPicker: UIView {

    // Init hsb for white color
    private var selectedHSB = HSB(hue: 0, saturation: 0, brightness: 1, alpha: 1)
    public weak var delegate: ColorPickerViewDelegate?

    let colorWheelLayer = CALayer()
    private lazy var indicatorLayer: CALayer = {
        let diameter = indicatorDiameter

        let indicatorLayer = CALayer()
        indicatorLayer.cornerRadius = diameter / 2
        indicatorLayer.backgroundColor = UIColor.white.cgColor
        indicatorLayer.bounds = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        indicatorLayer.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        indicatorLayer.shadowColor = UIColor.black.cgColor
        indicatorLayer.shadowOffset = .zero
        indicatorLayer.shadowRadius = 1
        indicatorLayer.shadowOpacity = 0.5
        return indicatorLayer
    }()

    @IBInspectable public var colorWheelBorderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = colorWheelBorderWidth
        }
    }

    @IBInspectable public var colorWheelBorderColor: UIColor? {
        didSet {
            layer.borderColor = colorWheelBorderColor?.cgColor
        }
    }

    @IBInspectable public var indicatorBorderWidth: CGFloat = 1 {
        didSet {
            indicatorLayer.borderWidth = indicatorBorderWidth
        }
    }

    @IBInspectable public var indicatorBorderColor: UIColor? = UIColor(white: 0.9, alpha: 0.8) {
        didSet {
            indicatorLayer.borderColor = indicatorBorderColor?.cgColor
        }
    }

    @IBInspectable public var indicatorDiameter: CGFloat = 40 {
        didSet {
            indicatorLayer.bounds.size = CGSize(width: indicatorDiameter, height: indicatorDiameter)
            indicatorLayer.cornerRadius = indicatorDiameter / 2
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        // configure color wheel layer
        colorWheelLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        colorWheelLayer.contents = createHSColorWheelImage(size: frame.size)
        colorWheelLayer.borderWidth = colorWheelBorderWidth
        colorWheelLayer.borderColor = colorWheelBorderColor?.cgColor
        colorWheelLayer.cornerRadius = min(colorWheelLayer.frame.width, colorWheelLayer.frame.height) / 2
        colorWheelLayer.masksToBounds = true
        layer.addSublayer(colorWheelLayer)

//        layer.contents = createHSColorWheelImage(size: frame.size)
//        layer.borderWidth = colorWheelBorderWidth
//        layer.borderColor = colorWheelBorderColor?.cgColor
//        layer.cornerRadius = min(frame.width, frame.height) / 2
//        layer.masksToBounds = true

        // configure indicator layer
        indicatorLayer.borderWidth = indicatorBorderWidth
        indicatorLayer.borderColor = indicatorBorderColor?.cgColor
        layer.addSublayer(indicatorLayer)
    }

    public func setBrightness(_ brightness: CGFloat) {
        selectedHSB.brightness = brightness
        colorWheelLayer.contents = createHSColorWheelImage(size: frame.size)

        let selectedColor = UIColor(
            hue: selectedHSB.hue,
            saturation: selectedHSB.saturation,
            brightness: selectedHSB.brightness,
            alpha: selectedHSB.alpha
        )
        indicatorLayer.backgroundColor = selectedColor.cgColor
    }
}

// MARK: - Touch Action
extension ColorPicker {

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let position = touches.first?.location(in: self) else { return }
        didTouch(at: position)
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let position = touches.first?.location(in: self) else { return }
        didTouch(at: position)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let position = touches.first?.location(in: self) else { return }
        didTouch(at: position)
    }

    func didTouch(at point: CGPoint) {
        let colorWheelRadius = frame.width / 2

        let dx = Double(colorWheelRadius - point.x)
        let dy = Double(colorWheelRadius - point.y)
        let distance = CGFloat(sqrt(dx * dx + dy * dy))

        // Check drag distance and move indicator
        guard distance < colorWheelRadius else { return }
        indicatorLayer.position = point

        // MARK: Research exclusive memory access
        var hue = CGFloat()
        var saturation = CGFloat()
        getHSValue(at: point, hue: &hue, saturation: &saturation)
        selectedHSB.hue = hue
        selectedHSB.saturation = saturation
        let selectedColor = UIColor(
            hue: selectedHSB.hue,
            saturation: selectedHSB.saturation,
            brightness: selectedHSB.brightness,
            alpha: selectedHSB.alpha
        )
        indicatorLayer.backgroundColor = selectedColor.cgColor
        delegate?.colorPicker(self, didSelect: selectedColor)
    }
}

// MARK: - Helpers
extension ColorPicker {

    func createHSColorWheelImage(size: CGSize) -> CGImage {
        // Creates a bitmap of the Hue Saturation colorWheel
        let colorWheelDiameter = Int(colorWheelLayer.frame.width)
        let bufferLength = Int(colorWheelDiameter * colorWheelDiameter * 4)

        let bitmapData: CFMutableData = CFDataCreateMutable(nil, 0)
        CFDataSetLength(bitmapData, CFIndex(bufferLength))
        let bitmap = CFDataGetMutableBytePtr(bitmapData)

        for y in 0 ..< colorWheelDiameter {
            for x in 0 ..< colorWheelDiameter {
                var hue: CGFloat = 0
                var saturation: CGFloat = 0
                var alpha: CGFloat = 0
                var rgb = RGB(red: 0, green: 0, blue: 0, alpha: 0)

                let point = CGPoint(x: x, y: y)
                getHSValue(at: point, hue: &hue, saturation: &saturation)
                if saturation < 1.0 {
                    // Antialias the edge of the circle.
                    if saturation > 0.99 {
                        alpha = (1.0 - saturation) * 100
                    } else {
                        alpha = 1.0
                    }

                    let hsb = HSB(hue: hue, saturation: saturation, brightness: selectedHSB.brightness, alpha: alpha)
                    rgb = convertHSBToRGB(hsb)
                }
                let offset = Int(4 * (x + y * colorWheelDiameter))
                bitmap?[offset] = UInt8(rgb.red * 255)
                bitmap?[offset + 1] = UInt8(rgb.green * 255)
                bitmap?[offset + 2] = UInt8(rgb.blue * 255)
                bitmap?[offset + 3] = UInt8(rgb.alpha * 255)
            }
        }

        // Convert the bitmap to a CGImage
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let dataProvider = CGDataProvider(data: bitmapData)
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.last.rawValue)
        let imageRef = CGImage(
            width: Int(colorWheelDiameter),
            height: Int(colorWheelDiameter),
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: Int(colorWheelDiameter) * 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            provider: dataProvider!,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent)
        return imageRef!
    }

    func getHSValue(at point: CGPoint, hue: inout CGFloat, saturation: inout CGFloat) {
        // Get hue and saturation for a given point (x,y) in the colorWheel
        let colorWheelRadius = colorWheelLayer.frame.width / 2
        let dx = CGFloat(point.x - colorWheelRadius) / colorWheelRadius
        let dy = CGFloat(point.y - colorWheelRadius) / colorWheelRadius
        let d = sqrt(dx * dx + dy * dy)

        saturation = d
        if d == 0 {
            hue = 0
        } else {
            hue = acos(dx / d) / .pi / 2.0

            if dy < 0 {
                hue = 1.0 - hue
            }
        }
    }
}
