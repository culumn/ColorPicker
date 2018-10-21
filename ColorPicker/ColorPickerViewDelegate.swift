//
//  ColorPickerViewDelegate.swift
//  ColorPicker
//
//  Created by Matsuoka Yoshiteru on 2018/10/20.
//  Copyright © 2018年 culumn. All rights reserved.
//

import Foundation

public protocol ColorPickerViewDelegate: class {
    func colorPickerWillBeginDragging(_ colorPicker: ColorPickerView)
    func colorPickerDidSelectColor(_ colorPicker: ColorPickerView)
    func colorPickerDidEndDagging(_ colorPicker: ColorPickerView)
}
