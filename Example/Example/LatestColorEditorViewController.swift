//
//  LatestColorEditorViewController.swift
//  Example
//
//  Created by Matsuoka Yoshiteru on 2018/10/21.
//  Copyright © 2018年 culumn. All rights reserved.
//

import UIKit
import ColorPicker

protocol LatestColorEditorViewControllerDelegate: class {
    func viewController(
        _ latestColorEditorViewController: LatestColorEditorViewController,
        didEdit color: UIColor?
    )
}

class LatestColorEditorViewController: UIViewController {

    weak var delegate: LatestColorEditorViewControllerDelegate?

    @IBOutlet weak var colorPicker: ColorPickerView!

    var selectedColor: UIColor? = .white

    override func viewDidLoad() {
        super.viewDidLoad()

        colorPicker.delegate = self
        colorPicker.updateSelectedColor(selectedColor)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }

    @IBAction func didTapCloseButton(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate?.viewController(self, didEdit: self.selectedColor)
        }
    }
}

extension LatestColorEditorViewController: ColorPickerViewDelegate {

    func colorPickerWillBeginDragging(_ colorPicker: ColorPickerView) {
        selectedColor = colorPicker.selectedColor
    }

    func colorPickerDidSelectColor(_ colorPicker: ColorPickerView) {
        selectedColor = colorPicker.selectedColor
    }

    func colorPickerDidEndDagging(_ colorPicker: ColorPickerView) {
        selectedColor = colorPicker.selectedColor
    }
}
