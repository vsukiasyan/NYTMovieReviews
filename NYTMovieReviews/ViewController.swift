//
//  ViewController.swift
//  NYTMovieReviews
//
//  Created by Vic Sukiasyan on 4/12/18.
//  Copyright © 2018 Vic Sukiasyan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var movies = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        parseJSON()
    }
    
    func parseJSON() {
        let url = URL(string: "http://api.nytimes.com/svc/movies/v2/reviews/search.json?api-key=789d42aacbc440d4add570e12f635526&query=fantastic")
    
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error ) in
            guard error == nil else {
                print("No error")
                return
            }
            
            guard let content = data else {
                print("No data")
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: content, options: []) as? [String:Any]
            let results = json!!["results"] as? [Any]
            //print(results!)
            
            for i in results! {
                let i = i as? [String: Any]
                self.movies.append((i!["display_title"] as? String)!)
            }
            //print(self.movies)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
        searchBar.resignFirstResponder()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = movies[indexPath.row]
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

