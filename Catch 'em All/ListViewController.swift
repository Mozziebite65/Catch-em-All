//
//  ListViewController.swift
//  Catch 'em All
//
//  Created by Rick Martin on 30/06/2021.
//

import UIKit

class ListViewController: UIViewController {

    
    @IBOutlet var tableView: UITableView!
    
    var creatures = Creatures()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //creatures = ["Bulbasaur", "Pikachu", "Snorlax", "Wigglytuff", "Charmander"]
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Get the creatures data. The code in the curlies is the closure code that will be passed to the function as the "completed" parameter.
        creatures.getData {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    
    }

}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return creatures.creatureArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("\(indexPath.row + 1) of \(creatures.creatureArray.count)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // check if there is more data in other URLs
        if indexPath.row == creatures.creatureArray.count - 1 && creatures.urlString.hasPrefix("https") {
            
            // Get the next 20 from the "next" URL in the API
            creatures.getData {
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        }
        
        cell.textLabel?.text = "\(indexPath.row + 1). \(creatures.creatureArray[indexPath.row].name)"
        
        return cell
        
    }

}
