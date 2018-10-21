//
//  ViewController.swift
//  Example
//
//  Created by Matsuoka Yoshiteru on 2018/10/19.
//  Copyright © 2018年 culumn. All rights reserved.
//

import UIKit
import ColorPicker

class ViewController: UIViewController {

    @IBOutlet weak var colorPicker: ColorPicker!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var `switch`: UISwitch!

    lazy var isHiddenIndicatorWhileDragging = !`switch`.isOn

    override func viewDidLoad() {
        super.viewDidLoad()

        colorPicker.delegate = self
        let color = #colorLiteral(red: 0.8887520799, green: 0.7259494958, blue: 0.8883424245, alpha: 1)
        colorPicker.updateSelectedColor(color)
        slider.value = Float(color.hsb.brightness)

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

extension ViewController: ColorPickerViewDelegate {

    func colorPickerWillBeginDragging(_ colorPicker: ColorPicker) {
        selectedColorView.backgroundColor = colorPicker.selectedColor
        guard isHiddenIndicatorWhileDragging else { return }
        colorPicker.isIndicatorHidden = true
    }

    func colorPickerDidSelectColor(_ colorPicker: ColorPicker) {
        selectedColorView.backgroundColor = colorPicker.selectedColor
    }

    func colorPickerDidEndDagging(_ colorPicker: ColorPicker) {
        selectedColorView.backgroundColor = colorPicker.selectedColor
        guard isHiddenIndicatorWhileDragging else { return }
        colorPicker.isIndicatorHidden = false
    }
}

