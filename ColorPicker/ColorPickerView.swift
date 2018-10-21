//
//  ColorWheelView.swift
//  ColorPicker
//
//  Created by Matsuoka Yoshiteru on 2018/10/19.
//  Copyright © 2018年 culumn. All rights reserved.
//

import Foundation

public class ColorPickerView: UIView {

    /// The selected color information in a HSB colorspace.
    private var selectedHSB = UIColor.white.hsb

    /// Current selected color in color picker.
    public var selectedColor: UIColor {
        return selectedHSB.color
    }

    /// The object that acts as the delegate of the color picker.
    public weak var delegate: ColorPickerViewDelegate?

    @IBInspectable public var isIndicatorHidden: Bool = false {
        didSet {
            indicatorLayer.isHidden = isIndicatorHidden

            // If `isIndicatorHidden` is false, update indicator's position and background color
            // to current selected color
            if !isIndicatorHidden {
                updateIndicatorToSelectedColorIfNotHidden()
            }
        }
    }

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

    private lazy var indicatorLayer: CALayer = {
        let diameter = indicatorDiameter

        let indicatorLayer = CALayer()
        indicatorLayer.cornerRadius = diameter / 2
        indicatorLayer.bounds = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        indicatorLayer.shadowColor = UIColor.black.cgColor
        indicatorLayer.shadowOffset = .zero
        indicatorLayer.shadowRadius = 1
        indicatorLayer.shadowOpacity = 0.5
        return indicatorLayer
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        // Configure color wheel layer
        layer.contents = createHSColorWheelImage(size: frame.size)
        layer.borderWidth = colorWheelBorderWidth
        layer.borderColor = colorWheelBorderColor?.cgColor
        layer.cornerRadius = min(frame.width, frame.height) / 2

        // Configure indicator layer
        indicatorLayer.borderWidth = indicatorBorderWidth
        indicatorLayer.borderColor = indicatorBorderColor?.cgColor
        updateIndicatorToSelectedColorIfNotHidden()
        layer.addSublayer(indicatorLayer)
    }

    /// Update the brightness component to current selected color
    ///
    /// - Parameter brightness: The new brightness components
    public func updateBrightness(_ brightness: CGFloat) {
        selectedHSB.brightness = brightness
        layer.contents = createHSColorWheelImage(size: frame.size)
        updateIndicatorToSelectedColorIfNotHidden()
        delegate?.colorPickerDidSelectColor(self)
    }

    /// Update the current selected color
    ///
    /// - Parameter color: The new color
    public func updateSelectedColor(_ color: UIColor) {
        selectedHSB = color.hsb
        layer.contents = createHSColorWheelImage(size: frame.size)
        updateIndicatorToSelectedColorIfNotHidden()
    }
}

// MARK: - Touch Action
extension ColorPickerView {

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        // If touches in this view, move indicator and update the selected color.
        guard let position = touches.first?.location(in: self),
            isTouchesInWheelView(touchedPoint: position) else { return }

        updateSelectedColor(at: position)
        updateIndicatorToSelectedColorIfNotHidden()
        delegate?.colorPickerWillBeginDragging(self)
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        // If touches in this view, move indicator and update the selected color.
        guard let position = touches.first?.location(in: self),
            isTouchesInWheelView(touchedPoint: position) else { return }

        updateSelectedColor(at: position)
        updateIndicatorToSelectedColorIfNotHidden()
        delegate?.colorPickerDidSelectColor(self)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        // If touches in this view, move indicator and update the selected color.
        guard let position = touches.first?.location(in: self),
            isTouchesInWheelView(touchedPoint: position) else { return }

        updateSelectedColor(at: position)
        updateIndicatorToSelectedColorIfNotHidden()
        delegate?.colorPickerDidEndDagging(self)
    }

    private func isTouchesInWheelView(touchedPoint: CGPoint) -> Bool {
        // Calculate distance
        let colorWheelRadius = frame.width / 2
        let dx = Double(colorWheelRadius - touchedPoint.x)
        let dy = Double(colorWheelRadius - touchedPoint.y)
        let distance = CGFloat(sqrt(dx * dx + dy * dy))

        return distance < colorWheelRadius
    }

    private func updateSelectedColor(at touchedPoint: CGPoint) {
        // Get hue and saturation value from touched point
        var hue = CGFloat()
        var saturation = CGFloat()
        getHSValue(at: touchedPoint, hue: &hue, saturation: &saturation)
        selectedHSB.hue = hue
        selectedHSB.saturation = saturation
    }

    private func updateIndicatorToSelectedColorIfNotHidden() {
        // If `isIndicatorHidden` is hidden, not update the indicator
        guard !isIndicatorHidden else { return }
        indicatorLayer.backgroundColor = selectedColor.cgColor

        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        indicatorLayer.position = getPointFromHS(hue: selectedHSB.hue, saturation: selectedHSB.saturation)
        CATransaction.commit()
    }
}

// MARK: - Helpers
extension ColorPickerView {

    private func createHSColorWheelImage(size: CGSize) -> CGImage {
        // Create a bitmap of the Hue Saturation colorWheel
        let colorWheelDiameter = Int(frame.width)
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
                    rgb = ColorSpaceConverter.convertToRGB(hsb: hsb)
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

    /// Get hue and saturation component for a given point in the color wheel.
    ///
    /// - Parameters:
    ///   - point: The point in the color wheel.
    ///   - hue: On return, the hue component for given point.
    ///   - saturation: On return, the saturation component for given point.
    private func getHSValue(at point: CGPoint, hue: inout CGFloat, saturation: inout CGFloat) {
        let colorWheelRadius = frame.width / 2
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

    /// Get point in the color wheel for a given hue and saturation component.
    ///
    /// - Parameters:
    ///   - hue: The hue component for HSB.
    ///   - saturation: The saturation component for HSB.
    /// - Returns: The point in the color wheel corresponding the hue and saturation component.
    private func getPointFromHS(hue: CGFloat, saturation: CGFloat) -> CGPoint {
        let colorWheelDiameter = frame.width
        let radius = saturation * colorWheelDiameter / 2
        let x = colorWheelDiameter / 2 + radius * cos(hue * .pi * 2)
        let y = colorWheelDiameter / 2 + radius * sin(hue * .pi * 2)
        return CGPoint(x: x, y: y)
    }
}
