//
//  ViewController.swift
//  IOSProject
//
//  Created by Emilien Champion on 24/02/2021.
//

import UIKit

class CharacterListController: UITableViewController {
    
    private enum Section {
        case main
    }
    
    private enum Item: Hashable {
        case character(SerieCharacter)
    }
    
    private var diffableDataSource: UITableViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        diffableDataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView,
        cellProvider: {
            (tableView, indexPath item) -> UITableViewCell? in
        })
    }

    

}

