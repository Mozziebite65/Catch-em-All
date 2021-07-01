//
//  CreatureDetail.swift
//  Catch 'em All
//
//  Created by Rick Martin on 01/07/2021.
//

import Foundation

class CreatureDetail {
    
    var height: Double = 0.0
    var weight: Double = 0.0
    var imageURL: String = ""
    var urlString: String = ""
    
    private struct Returned: Codable {
        
        var height: Double
        var weight: Double
        var sprites: Sprites
        
    }
    
    private struct Sprites: Codable {
        
        var front_default: String
        
    }
    
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
                self.height = returnedData.height
                self.weight = returnedData.weight
                self.imageURL = returnedData.sprites.front_default
                
            } catch {
                
                print("😡 JSON ERROR: thrown when we tried to decode from Returned.self with data")
                
            }
            
            // Got the data - run the closure code which was passes into the getData() function  from the other VC
            completed()
            
        }
        
        task.resume()
        
    }
    
    
    
    
    
}
