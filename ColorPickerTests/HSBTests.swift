//
//  HSBTests.swift
//  ColorPickerTests
//
//  Created by Matsuoka Yoshiteru on 2018/11/05.
//  Copyright © 2018 culumn. All rights reserved.
//

import XCTest
@testable import ColorPicker

class HSBTests: XCTestCase {

    func testHSBInit() {
        let hue: CGFloat = 0.25
        let saturation: CGFloat = 0.5
        let brightness: CGFloat = 0.75
        let alpha: CGFloat = 1.0

        let hsb = HSB(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)

        XCTAssertEqual(hsb.hue, hue)
        XCTAssertEqual(hsb.saturation, saturation)
        XCTAssertEqual(hsb.brightness, brightness)
        XCTAssertEqual(hsb.alpha, alpha)
    }

    func testHSBToUIColor() {
        let hsb = HSB(hue: 0.25, saturation: 0.5, brightness: 0.75, alpha: 1.0)
        let expextedColor = UIColor(hue: 0.25, saturation: 0.5, brightness: 0.75, alpha: 1.0)

        XCTAssertEqual(hsb.color, expextedColor)
    }
}
