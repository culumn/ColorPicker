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

    func testRGBInit() {
        let red: CGFloat = 0.25
        let green: CGFloat = 0.5
        let blue: CGFloat = 0.75
        let alpha: CGFloat = 1.0

        let rgb = RGB(red: red, green: green, blue: blue, alpha: alpha)

        XCTAssertEqual(rgb.red, red)
        XCTAssertEqual(rgb.green, green)
        XCTAssertEqual(rgb.blue, blue)
        XCTAssertEqual(rgb.alpha, alpha)
    }

    func testRGBToUIColor() {
        let rgb = RGB(red: 0.25, green: 0.5, blue: 0.75, alpha: 1.0)
        let expextedColor = UIColor(red: 0.25, green: 0.5, blue: 0.75, alpha: 1.0)

        XCTAssertEqual(rgb.color, expextedColor)
    }
}
