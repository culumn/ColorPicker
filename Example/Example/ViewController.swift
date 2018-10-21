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

    @IBOutlet weak var constraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        colorPicker.delegate = self
        let color = #colorLiteral(red: 0.8887520799, green: 0.7259494958, blue: 0.8883424245, alpha: 1)
        colorPicker.updateSelectedColor(color)

        slider.value = Float(color.hsb.brightness)
    }

    @IBAction func didChangeSliderValue(_ sender: UISlider) {
        let value = CGFloat(sender.value)
        if value < 0.5 {
//            colorPicker.frame.size = CGSize(width: 100, height: 100)
            if !colorPicker.isIndicatorHidden {
                colorPicker.isIndicatorHidden = true
            }
        } else {
//            colorPicker.frame.size = CGSize(width: 300, height: 300)
            if colorPicker.isIndicatorHidden {
                colorPicker.isIndicatorHidden = false
            }
//            colorPicker.isIndicatorHidden = false
        }

        DispatchQueue.main.async {
            self.colorPicker.updateBrightness(value)
        }
    }
}

extension ViewController: ColorPickerViewDelegate {
    func colorPickerDidEndEditingColor(_ colorPicker: ColorPicker) {

    }

    func colorPickerDidEndDagging(_ colorPicker: ColorPicker) {

    }
}

