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
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //creatures = ["Bulbasaur", "Pikachu", "Snorlax", "Wigglytuff", "Charmander"]
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setUpActivityIndicator()
        
        // Get the creatures data. The code in the curlies is the closure code that will be passed to the function as the "completed" parameter.

        // Set the spinny wheel while the data is retrieved
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        creatures.getData {
            
            DispatchQueue.main.async {
                
                self.navigationItem.title = "\(self.creatures.creatureArray.count) of \(self.creatures.count) Pokemon"
                self.tableView.reloadData()
                
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                
            }
            
        }

    }
    
    
    func setUpActivityIndicator() {
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = UIColor.red
        view.addSubview(activityIndicator)
        
    }
    
    func loadAll() {
        
        if creatures.urlString.hasPrefix("http") {
            
            creatures.getData {
                
                DispatchQueue.main.async {
                    
                    self.navigationItem.title = "\(self.creatures.creatureArray.count) of \(self.creatures.count) Pokemon"
                    self.tableView.reloadData()
  
                }
                
                self.loadAll()      // Recursive call - keep looping until the "next" value is null
            }
            
        } else {
            
            DispatchQueue.main.async {
                
                print("All done - all loaded. Total Pokemon = \(self.creatures.creatureArray.count)")
                
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetail" {       // Don't need this, but...
            
            let destVC = segue.destination as! DetailViewController
            let selectedIndexPathRow = tableView.indexPathForSelectedRow!.row
            destVC.creature = creatures.creatureArray[selectedIndexPathRow]
            
        }
    }
    
    @IBAction func loadAllButtonPressed(_ sender: UIBarButtonItem) {
        
        // Set the spinny wheel while the data is retrieved
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        loadAll()
        
    }

}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return creatures.creatureArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("\(indexPath.row + 1) of \(creatures.creatureArray.count)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // check if there is more data in other URLs ***** IF ***** we have scrolled to the bottom of the current loaded rows
        if indexPath.row == creatures.creatureArray.count - 1 && creatures.urlString.hasPrefix("https") {
            
            // Get the next 20 from the "next" URL in the API
            
            // Set the spinny wheel while the data is retrieved
            activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
            
            creatures.getData {
                
                DispatchQueue.main.async {
                    
                    self.navigationItem.title = "\(self.creatures.creatureArray.count) of \(self.creatures.count) Pokemon"
                    self.tableView.reloadData()
                    
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    
                }
                
            }
            
        }
        
        cell.textLabel?.text = "\(indexPath.row + 1). \(creatures.creatureArray[indexPath.row].name)"
        
        return cell
        
    }

}
