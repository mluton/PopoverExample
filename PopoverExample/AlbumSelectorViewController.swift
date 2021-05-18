//
//  AlbumSelectorViewController.swift
//  PopoverExample
//
//  Created by Michael Luton on 5/13/21.
//

import UIKit

protocol AlbumSelectorDelegate: AnyObject {
    func albumSelected(albumTitle: String)
}

class AlbumSelectorViewController: UIViewController {

    let albums = [
        "Signals",
        "Grace Under Pressure",
        "Power Windows",
        "Hold Your Fire"
//        "Presto",
//        "Roll The Bones",
//        "Counterparts",
//        "Test For Echo",
//        "Vapor Trails",
//        "Snakes & Arrows",
//        "Clockwork Angels"
    ]

    let paddingRequired = true
    let reuseIdentifier = "Cell"
    let customFontName = "Zapfino"
    let customFontSize: CGFloat = 24.0
    let verticalPadding: CGFloat = 10.0
    let horizontalPadding: CGFloat = 60.0
    let minimumWidth: CGFloat = 0.0
    let maximumHeight: CGFloat = 800.0
    var rowHeight: CGFloat = 0.0
    var selectedAlbum = 0

    weak var delegate: AlbumSelectorDelegate?

    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let contentSize = calculateContentSize(for: albums)
        preferredContentSize = contentSize
    }

    private func calculateContentSize(for albumTitles: [String]) -> CGSize {
        var contentWidth: CGFloat = 0.0
        var contentHeight: CGFloat = 0.0

        for albumTitle in albumTitles {
            let font = UIFont(name: customFontName, size: customFontSize)
            let fontAttributes = [NSAttributedString.Key.font: font]
            let requiredSize = (albumTitleForPopover(albumTitle) as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])

            if (requiredSize.width + horizontalPadding > contentWidth) {
                contentWidth = requiredSize.width + horizontalPadding;
            }

            if (requiredSize.height + verticalPadding > self.rowHeight) {
                self.rowHeight = requiredSize.height + verticalPadding
            }

            contentHeight += requiredSize.height + verticalPadding
        }

        return CGSize(width: max(contentWidth, minimumWidth), height: min(contentHeight, maximumHeight))
    }

    private func albumTitleForPopover(_ albumTitle: String) -> String {
        return paddingRequired ? " \(albumTitle) " : albumTitle
    }
}

extension AlbumSelectorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath as IndexPath)
        cell.textLabel?.font = UIFont(name: customFontName, size: customFontSize)
        cell.textLabel?.text = albumTitleForPopover(albums[indexPath.row])
        cell.accessoryType = selectedAlbum == indexPath.row ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        rowHeight
    }
}

extension AlbumSelectorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != selectedAlbum else {
            return
        }

        let previouslySelectedAlbum = selectedAlbum
        selectedAlbum = indexPath.row

        let oldIndexPath = IndexPath(row: previouslySelectedAlbum, section: 0)
        let newIndexPath = IndexPath(row: selectedAlbum, section: 0)
        let rowsToRefresh = [oldIndexPath, newIndexPath]

        tableView.reloadRows(at: rowsToRefresh, with: UITableView.RowAnimation.fade)

        delegate?.albumSelected(albumTitle: albums[selectedAlbum])
    }
}
