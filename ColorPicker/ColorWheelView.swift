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

    public weak var delegate: ColorPickerViewDelegate?

    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)


    }

}
