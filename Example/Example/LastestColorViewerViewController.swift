//
//  LastestColorShowViewController.swift
//  Example
//
//  Created by Matsuoka Yoshiteru on 2018/10/21.
//  Copyright © 2018年 culumn. All rights reserved.
//

import UIKit

class LastestColorViewerViewController: UIViewController {

    @IBOutlet weak var latestColorview: UIView!

    var selectedcolor = UIColor.white {
        didSet {
            latestColorview.backgroundColor = selectedcolor
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        latestColorview.layer.cornerRadius = 20
        latestColorview.clipsToBounds = true
        latestColorview.layer.borderColor = UIColor.black.cgColor
        latestColorview.layer.borderWidth = 1
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        latestColorview.backgroundColor = selectedcolor
//    }

    @IBAction func didTapEditButton(_ sender: UIButton) {
        guard let editorVC = storyboard?.instantiateViewController(withIdentifier: "LatestColorEditorViewController") as? LatestColorEditorViewController else { fatalError() }
        editorVC.delegate = self
        editorVC.selectedColor = selectedcolor
        editorVC.modalPresentationStyle = .overCurrentContext
        editorVC.modalTransitionStyle = .crossDissolve
        present(editorVC, animated: true)
    }
}

extension LastestColorViewerViewController: LatestColorEditorViewControllerDelegate {

    func viewController(_ latestColorEditorViewController: LatestColorEditorViewController, didEdit color: UIColor) {
        selectedcolor = color
    }
}
