//
//  DetailViewController.swift
//  Catch 'em All
//
//  Created by Rick Martin on 01/07/2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    // Catcher variable
    var creature: Creature!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        nameLabel.text = creature.name

        let creatureDetail = CreatureDetail()
        creatureDetail.urlString = creature.url
        
        creatureDetail.getData {
            
            DispatchQueue.main.async {
                
                // Fill in the labels
                self.heightLabel.text = String(creatureDetail.height)
                self.weightLabel.text = String(creatureDetail.weight)
                
                // Get a URL object from the string
                guard let returnedImageURL = URL(string: creatureDetail.imageURL) else { return }
                
                do {
                    
                    // get a Data object from the URL
                    let imageData = try Data(contentsOf: returnedImageURL)
                    // and put in the imageView
                    self.imageView.image = UIImage(data: imageData)
                    
                } catch {
                    
                    print("😡ERROR: error creating Data object from URL object \(returnedImageURL)")
                    
                }

            }
        }
        
    }
}
