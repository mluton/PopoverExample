//
//  ViewController.swift
//  PopoverExample
//
//  Created by Michael Luton on 5/13/21.
//

import UIKit

class ViewController: UIViewController {

    var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Button", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(button)

        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 120.0)
        ])
    }

    @objc func buttonPressed() {
        let albumSelector = AlbumSelectorViewController()
        albumSelector.delegate = self
        albumSelector.modalPresentationStyle = .popover
        albumSelector.popoverPresentationController?.sourceView = button
        albumSelector.popoverPresentationController?.sourceRect = button.bounds
        present(albumSelector, animated: true, completion: nil)
    }
}

extension ViewController: AlbumSelectorDelegate {
    func albumSelected(albumTitle: String) {
        print(albumTitle)
    }
}
