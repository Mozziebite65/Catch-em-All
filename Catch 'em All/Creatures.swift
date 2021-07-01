//
//  Creatures.swift
//  Catch 'em All
//
//  Created by Rick Martin on 30/06/2021.
//

import Foundation


class Creatures {
    
    private struct Returned: Codable {
        
        var count: Int = 0
        var next: String?
        var results: [Creature]

    }
    
    var count = 0
    var urlString = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=20"
    var creatureArray: [Creature] = []
    
    
    func getData(completed: @escaping ()->()) {

            print("🕸 We are accessing the URL string \(urlString)")
            
            // Create a URL
            guard let url = URL(string: urlString) else {
                
                print("😡 ERROR: Could not create a url object from \(urlString)")
                return
            }
            
            // Have a valid URL object... now create a session
            let session = URLSession.shared
            
            // get data with .dataTask method
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    print("😡 ERROR: \(error.localizedDescription)")
                }
                
                do {
                    
                    let returnedData = try JSONDecoder().decode(Returned.self, from: data!)
                    print("😎 This is what was returned: \(returnedData)")
                    self.urlString = returnedData.next ?? ""
                    self.count = returnedData.count
                    //self.creatureArray = returnedData.results
                    self.creatureArray.append(contentsOf: returnedData.results)
                    
                } catch {
                    
                    print("😡 JSON ERROR: thrown when we tried to decode from Returned.self with data")
                    
                }
                
                // Got the data - run the closure code which was passes into the getData() function  from the other VC
                completed()
                
            }
            
            task.resume()
       
    }
    
}


