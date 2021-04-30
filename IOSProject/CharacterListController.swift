//
//  ViewController.swift
//  IOSProject
//
//  Created by Emilien Champion on 24/02/2021.
//

import UIKit

class CharacterListController: UICollectionViewController {
    
    var serieCharacterList : [SerieCharacter] = []
    
    private enum Section {
        case main
    }
    
    private enum Item: Hashable {
        case character(SerieCharacter)
    }
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.collectionViewLayout = createLayout()
        
        diffableDataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView,
        cellProvider: {
            (tableView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .character(let character):
                let cell =
                    tableView.dequeueReusableCell(withReuseIdentifier: "character_list_cell", for: indexPath) as! CharacterCellCollectionViewCell
                cell.label.text = character.name
                cell.secondaryLabel.text = character.gender
                cell.image.loadImage(from: character.imageURL)
               
               
                return cell
            }
        })
        
        let snapshot = createSnapshot(serieCharacters: [])
        diffableDataSource.apply(snapshot)
        NetworkManager.sharedInstance.fetchCharacters { (result) in
            switch result {
            case .failure(let error):
                print(error)

            case .success(let paginatedElements):
                self.serieCharacterList = paginatedElements.decodedElements
                let snapshot = self.createSnapshot(serieCharacters: self.serieCharacterList)

                DispatchQueue.main.async {
                    self.diffableDataSource.apply(snapshot)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! CharacterDetailTableViewController
    }
    
    private func createSnapshot(serieCharacters: [SerieCharacter]) -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        
        let items = serieCharacters.map(Item.character)
        snapshot.appendItems(items, toSection: .main)
        
        return snapshot
    }

    private func createLayout() -> UICollectionViewLayout {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
    

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
       
        
        return UICollectionViewCompositionalLayout(sectionProvider: {
            (section, environnement) -> NSCollectionLayoutSection? in
            let snapshot = self.diffableDataSource.snapshot()
            let currentSection = snapshot.sectionIdentifiers[section]
            
            switch currentSection {
            case .main:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(260))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(260))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            }
        })
    }
    
    
    

}
extension CharacterListController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("test")
        let searchQuery = searchController.searchBar.text ?? ""
        if(searchQuery.isEmpty) {
            let snapshot = createSnapshot(serieCharacters: serieCharacterList)
            diffableDataSource.apply(snapshot)
        }
        else {
            var filteredSerieCharacter: [SerieCharacter] = []
            for character in serieCharacterList {
                if(character.name.contains(searchQuery) || character.gender.contains(searchQuery)) {
                    filteredSerieCharacter.append(character)
                }
                
            }
            let snapshot = createSnapshot(serieCharacters: filteredSerieCharacter)
            diffableDataSource.apply(snapshot)
        }
        // TODO: Update tableview row
       
       
    }
}

