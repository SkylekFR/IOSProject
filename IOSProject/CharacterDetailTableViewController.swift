//
//  CharacterDetailTableViewController.swift
//  IOSProject
//
//  Created by Emilien Champion on 30/04/2021.
//

import UIKit

class CharacterDetailTableViewController: UITableViewController {
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var characterCreatedDate: UILabel!
    @IBOutlet weak var characterGender: UILabel!
    
    var serieCharacter: SerieCharacter! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.loadImage(from: serieCharacter.imageURL)
        characterName.text = "Name: \(serieCharacter.name)"
        characterGender.text = "Gender: \(serieCharacter.gender)"
        characterCreatedDate.text = "Created at: \(serieCharacter.createdDate)"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


}
