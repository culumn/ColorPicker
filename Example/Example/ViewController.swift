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

    override func viewDidLoad() {
        super.viewDidLoad()

        colorPicker.delegate = self
    }
}

extension ViewController: ColorPickerViewDelegate {

    func colorPicker(_ colorPicker: ColorPicker, didSelect color: UIColor) {
        print(color)
    }
}

