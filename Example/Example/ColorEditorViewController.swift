//
//  ViewController.swift
//  Example
//
//  Created by Matsuoka Yoshiteru on 2018/10/19.
//  Copyright © 2018年 culumn. All rights reserved.
//

import UIKit
import ColorPicker

class ColorEditorViewController: UIViewController {

    @IBOutlet weak var colorPicker: ColorPickerView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var `switch`: UISwitch!

    lazy var isHiddenIndicatorWhileDragging = !`switch`.isOn

    override func viewDidLoad() {
        super.viewDidLoad()

        colorPicker.delegate = self

        selectedColorView.layer.cornerRadius = 20
        selectedColorView.clipsToBounds = true
        selectedColorView.layer.borderColor = UIColor.black.cgColor
        selectedColorView.layer.borderWidth = 1
    }

    @IBAction func didChangeSliderValue(_ sender: UISlider) {
        let value = CGFloat(sender.value)
        self.colorPicker.updateBrightness(value)
    }


    @IBAction func didChangeSwitchValue(_ sender: UISwitch) {
        isHiddenIndicatorWhileDragging = !sender.isOn
    }
}

extension ColorEditorViewController: ColorPickerViewDelegate {

    func colorPickerWillBeginDragging(_ colorPicker: ColorPickerView) {
        selectedColorView.backgroundColor = colorPicker.selectedColor
        guard isHiddenIndicatorWhileDragging else { return }
        colorPicker.isIndicatorHidden = true
    }

    func colorPickerDidSelectColor(_ colorPicker: ColorPickerView) {
        selectedColorView.backgroundColor = colorPicker.selectedColor
    }

    func colorPickerDidEndDagging(_ colorPicker: ColorPickerView) {
        selectedColorView.backgroundColor = colorPicker.selectedColor
        guard isHiddenIndicatorWhileDragging else { return }
        colorPicker.isIndicatorHidden = false
    }
}

