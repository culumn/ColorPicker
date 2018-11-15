//
//  RGBTests.swift
//  ColorPickerTests
//
//  Created by Matsuoka Yoshiteru on 2018/11/05.
//  Copyright © 2018 culumn. All rights reserved.
//

import XCTest
@testable import ColorPicker

class RGBTests: XCTestCase {

    func testRGBToUIColor() {
        let rgb = RGB(red: 0.25, green: 0.5, blue: 0.75, alpha: 1.0)
        let expextedColor = UIColor(red: 0.25, green: 0.5, blue: 0.75, alpha: 1.0)

        XCTAssertEqual(rgb.color, expextedColor)
    }
}
