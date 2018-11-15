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

    func testHSBToUIColor() {
        let hsb = HSB(hue: 0.25, saturation: 0.5, brightness: 0.75, alpha: 1.0)
        let expextedColor = UIColor(hue: 0.25, saturation: 0.5, brightness: 0.75, alpha: 1.0)

        XCTAssertEqual(hsb.color, expextedColor)
    }
}
